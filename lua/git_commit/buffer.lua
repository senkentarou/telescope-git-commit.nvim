local Buffer = {
  handle = nil,
}
Buffer.__index = Buffer

function Buffer:new(handle)
  local this = {
    handle = handle,
  }
  setmetatable(this, self)
  return this
end

function Buffer:set_lines(first, last, strict, lines)
  vim.api.nvim_buf_set_lines(self.handle, first, last, strict, lines)
end

function Buffer:set_option(name, value)
  vim.api.nvim_buf_set_option(self.handle, name, value)
end

function Buffer:set_name(name)
  vim.api.nvim_buf_set_name(self.handle, name)
end

function Buffer:set_filetype(ft)
  vim.cmd("setlocal filetype=" .. ft)
end

function Buffer:set_buftype(bt)
  vim.cmd("setlocal buftype=" .. bt)
end

function Buffer.create(config)
  config = config or {}

  local buffer = Buffer:new(vim.api.nvim_create_buf(false, true))

  vim.api.nvim_set_current_buf(buffer.handle)
  vim.api.nvim_exec([[
    set nonu
    set nornu
  ]], false)

  buffer:set_name(config.name)
  buffer:set_option("swapfile", false)

  if config.filetype then
    buffer:set_filetype(config.filetype)
  end

  if not config.modifiable then
    buffer:set_option("modifiable", false)
  end

  if config.readonly ~= nil and config.readonly then
    buffer:set_option("readonly", true)
  end

  config.initialize(buffer)

  return buffer
end

return Buffer
