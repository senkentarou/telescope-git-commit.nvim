local previewers = require('telescope.previewers')
local previewer_utils = require('telescope.previewers.utils')

local P = {}

P.previewer = function(opts)
  opts = opts or {}

  return previewers.new_buffer_previewer({
    title = 'diff cached changes',
    define_preview = function(self, entry)
      previewer_utils.job_maker({
        'git',
        '--no-pager',
        'diff',
        '--cached',
        '--unified=1',
      }, self.state.bufnr, {
        value = entry.value,
        bufname = self.state.bufname,
        cwd = opts.cwd or vim.loop.cwd(),
        callback = function(bufnr)
          if vim.api.nvim_buf_is_valid(bufnr) then
            previewer_utils.regex_highlighter(bufnr, 'diff')
          end
        end,
      })
    end,
  })
end

return P
