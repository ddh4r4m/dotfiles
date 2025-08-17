return {
  "echasnovski/mini.files",
  opts = {
    -- Customization of shown content
    content = {
      -- Predicate for which file system entries to show
      filter = nil,
      -- What prefix to show to the left of file system entry
      prefix = nil,
      -- In which order to show file system entries
      sort = nil,
    },

    -- Module mappings created only inside explorer.
    -- Use `''` (empty string) to not create one.
    mappings = {
      close = "q",
      go_in = "l",
      go_in_plus = "L",
      go_out = "h",
      go_out_plus = "H",
      mark_goto = "'",
      mark_set = "m",
      reset = "<BS>",
      reveal_cwd = "@",
      show_help = "g?",
      synchronize = "=",
      trim_left = "<",
      trim_right = ">",
    },

    -- General options
    options = {
      -- Whether to delete permanently or move into module-specific trash
      permanent_delete = true,
      -- Whether to use for editing directories
      use_as_default_explorer = true,
    },

    -- Customization of explorer windows
    windows = {
      -- Maximum number of windows to show side by side
      max_number = math.huge,
      -- Whether to show preview of file/directory under cursor
      preview = true,
      -- Width of focused window
      width_focus = 35,
      -- Width of non-focused window
      width_nofocus = 15,
      -- Width of preview window
      width_preview = 80,
    },
  },

  keys = {
    {
      "<leader>fm",
      function()
        require("mini.files").open(vim.api.nvim_buf_get_name(0), true)
      end,
      desc = "Open mini.files (Directory of Current File)",
    },
    {
      "<leader>fM",
      function()
        require("mini.files").open(vim.uv.cwd(), true)
      end,
      desc = "Open mini.files (cwd)",
    },
  },

  config = function(_, opts)
    require("mini.files").setup(opts)

    local show_dotfiles = true
    local filter_show = function(fs_entry)
      return true
    end
    local filter_hide = function(fs_entry)
      return not vim.startswith(fs_entry.name, ".")
    end

    -- Toggle dotfiles
    local toggle_dotfiles = function()
      show_dotfiles = not show_dotfiles
      local new_filter = show_dotfiles and filter_show or filter_hide
      require("mini.files").refresh({ content = { filter = new_filter } })
    end

    -- Auto-create directories when creating files
    local files_set_cwd = function()
      local cur_entry_path = MiniFiles.get_fs_entry().path
      local cur_directory = vim.fs.dirname(cur_entry_path)
      if cur_directory ~= nil then
        vim.fn.chdir(cur_directory)
      end
    end

    -- Create file/directory with automatic parent creation
    local map_split = function(buf_id, lhs, direction, close_on_file)
      local rhs = function()
        local new_target_window
        local cur_target_window = require("mini.files").get_target_window()
        if cur_target_window ~= nil then
          vim.api.nvim_win_call(cur_target_window, function()
            vim.cmd("belowright " .. direction .. " split")
            new_target_window = vim.api.nvim_get_current_win()
          end)
          require("mini.files").set_target_window(new_target_window)
          require("mini.files").go_in({ close_on_file = close_on_file })
        end
      end
      local desc = "Open in " .. direction .. " split"
      vim.keymap.set("n", lhs, rhs, { buffer = buf_id, desc = desc })
    end

    -- Enhanced file operations
    local create_file_with_dirs = function()
      local fs_entry = require("mini.files").get_fs_entry()
      if fs_entry == nil then
        return
      end

      local input = vim.fn.input("Create file: ", fs_entry.path .. "/")
      if input == "" then
        return
      end

      -- Create parent directories if they don't exist
      local parent_dir = vim.fs.dirname(input)
      if parent_dir and not vim.fn.isdirectory(parent_dir) then
        vim.fn.mkdir(parent_dir, "p")
      end

      -- Create the file
      vim.fn.writefile({}, input)
      require("mini.files").refresh()
    end

    -- Set up autocommands for enhanced functionality
    vim.api.nvim_create_autocmd("User", {
      pattern = "MiniFilesBufferCreate",
      callback = function(args)
        local buf_id = args.data.buf_id

        -- Toggle dotfiles
        vim.keymap.set("n", "g.", toggle_dotfiles, { buffer = buf_id, desc = "Toggle dotfiles" })

        -- Set CWD to current directory
        vim.keymap.set("n", "gc", files_set_cwd, { buffer = buf_id, desc = "Set CWD" })

        -- Create file with automatic directory creation
        vim.keymap.set("n", "gf", create_file_with_dirs, { buffer = buf_id, desc = "Create file (with dirs)" })

        -- Split mappings
        map_split(buf_id, "<C-s>", "horizontal", false)
        map_split(buf_id, "<C-v>", "vertical", false)

        -- Open in splits and close mini.files
        map_split(buf_id, "gs", "horizontal", true)
        map_split(buf_id, "gv", "vertical", true)

        -- Open in new tab
        vim.keymap.set("n", "<C-t>", function()
          local cur_target_window = require("mini.files").get_target_window()
          if cur_target_window ~= nil then
            vim.cmd("tabnew")
            local new_target_window = vim.api.nvim_get_current_win()
            require("mini.files").set_target_window(new_target_window)
            require("mini.files").go_in({ close_on_file = true })
          end
        end, { buffer = buf_id, desc = "Open in new tab" })

        -- Navigate to parent directory quickly
        vim.keymap.set("n", "-", function()
          require("mini.files").go_out()
        end, { buffer = buf_id, desc = "Go to parent directory" })

        -- Copy file path to clipboard
        vim.keymap.set("n", "gy", function()
          local fs_entry = require("mini.files").get_fs_entry()
          if fs_entry then
            vim.fn.setreg("+", fs_entry.path)
            vim.notify("Copied: " .. fs_entry.path)
          end
        end, { buffer = buf_id, desc = "Copy file path" })

        -- Copy relative path to clipboard
        vim.keymap.set("n", "gY", function()
          local fs_entry = require("mini.files").get_fs_entry()
          if fs_entry then
            local relative_path = vim.fn.fnamemodify(fs_entry.path, ":.")
            vim.fn.setreg("+", relative_path)
            vim.notify("Copied: " .. relative_path)
          end
        end, { buffer = buf_id, desc = "Copy relative path" })

        -- Quick bookmarks
        vim.keymap.set("n", "gh", function()
          require("mini.files").open(vim.fn.expand("~"))
        end, { buffer = buf_id, desc = "Go to home" })

        vim.keymap.set("n", "gr", function()
          require("mini.files").open(vim.fn.fnamemodify(vim.fn.finddir(".git", ".;"), ":h"))
        end, { buffer = buf_id, desc = "Go to git root" })
      end,
    })

    -- Auto-resize mini.files windows to use full available width
    vim.api.nvim_create_autocmd("User", {
      pattern = "MiniFilesWindowOpen",
      callback = function()
        vim.defer_fn(function()
          local all_wins = vim.api.nvim_list_wins()
          local minifiles_wins = {}

          -- Find all mini.files windows
          for _, win in ipairs(all_wins) do
            local buf = vim.api.nvim_win_get_buf(win)
            local buf_name = vim.api.nvim_buf_get_name(buf)
            if buf_name:match("mini%-files") then
              table.insert(minifiles_wins, win)
            end
          end

          -- Resize if we have 2 windows (explorer + preview)
          if #minifiles_wins == 2 then
            local total_width = vim.o.columns - 6 -- Leave margin for borders
            local explorer_width = math.floor(total_width * 0.3) -- 30% for explorer
            local preview_width = math.floor(total_width * 0.65) -- 65% for preview

            -- Set widths
            vim.api.nvim_win_set_width(minifiles_wins[1], explorer_width)
            vim.api.nvim_win_set_width(minifiles_wins[2], preview_width)
          end
        end, 100) -- Small delay to ensure windows are fully created
      end,
    })

    -- Auto-sync when files change
    vim.api.nvim_create_autocmd("User", {
      pattern = "MiniFilesActionRename",
      callback = function(event)
        require("mini.files").refresh()
      end,
    })
  end,
}
