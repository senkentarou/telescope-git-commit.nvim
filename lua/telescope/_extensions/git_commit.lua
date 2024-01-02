local builtin = require('git_commit.builtin')

return require('telescope').register_extension {
  exports = {
    git_commit = builtin.git_commit,
  },
}
