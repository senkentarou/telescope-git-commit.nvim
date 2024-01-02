local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')

local systems = require('git_commit.systems')
local Buffer = require('git_commit.buffer')

local function commit_with_file(filepath)
  local job = systems.create_job({
    command = 'git',
    args = {
      'commit',
      '-F',
      filepath,
    },
  })
  job:start()

  -- TODO: add callback message
end

local function create_commit_window(messages)
  local output = {}

  for _, line in ipairs(messages) do
    table.insert(output, line)
  end

  table.insert(output, '')
  table.insert(output, '')
  table.insert(output, "# Please enter the commit message for your changes. Lines starting")
  table.insert(output, "# with '#' will be ignored, and an empty message aborts the commit.")

  -- FIXME: smart way to get git root
  local filepath = '.git/COMMIT_EDITMSG'

  Buffer.create({
    name = filepath,
    filetype = 'gitcommit',
    modifiable = true,
    readonly = false,
    initialize = function(buffer)
      buffer:set_lines(0, -1, false, output)
      buffer:set_buftype('')

      vim.api.nvim_create_autocmd({
        'BufWritePost',
      }, {
        buffer = buffer.handle,
        callback = function()
          vim.api.nvim_exec([[
            silent g/^#/d
            silent w!
            silent bw!
          ]], false)

          commit_with_file(filepath)
        end,
      })
    end,
  })
end

local A = {}

A.open_commit_msgedit = function(bufnr)
  -- close telescope window
  actions.close(bufnr)

  -- get emoji
  local selection = action_state.get_selected_entry()
  local prefix = selection.value.emoji

  create_commit_window({
    prefix .. ' ',
  })
end

return A
