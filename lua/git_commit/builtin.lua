local telescope_actions = require('telescope.actions')
local pickers = require('telescope.pickers')
local config = require('telescope.config').values

local actions = require('git_commit.actions')
local finders = require('git_commit.finders')
local previewers = require('git_commit.previewers')

local B = {}

B.git_commit = function(opts)
  opts = opts or {}

  pickers.new(opts, {
    prompt_title = 'Git Commit',
    results_title = 'Select commit message prefix',
    finder = finders.finder(opts),
    previewer = previewers.previewer(opts),
    sorter = config.generic_sorter(opts),
    attach_mappings = function(_, _)
      -- <CR> action
      telescope_actions.select_default:replace(actions.open_commit_msgedit)
      return true
    end,
  }):find()
end

return B
