local finders = require('telescope.finders')

local gitmojis = require('git_commit.gitmojis').gitmojis

local F = {}

local function make_entry(entry)
  local size = (F.max_width or 1) - vim.api.nvim_strwidth(entry.emoji) + 1
  local display = entry.emoji .. string.rep(' ', size) .. '│ ' .. entry.description

  return {
    value = entry,
    display = display,
    ordinal = display,
  }
end

local function set_max_width(size)
  F.max_width = size
end

F.finder = function(opts)
  opts = opts or {}

  -- merge user sets into default sets
  local mojis = vim.tbl_extend('force', gitmojis, opts.gitmojis or {})

  -- calculate max width
  local size = 1
  for _, value in pairs(mojis) do
    local s = vim.api.nvim_strwidth(value.emoji)
    if s > size then
      size = s
    end
  end
  set_max_width(size)

  return finders.new_table({
    results = mojis,
    entry_maker = make_entry,
  })
end

return F
