local E = {}

-- TODO: replace to json, then load and parse it.
E.gitmojis = {
  -- https://github.com/carloscuesta/gitmoji/blob/master/packages/gitmojis/src/gitmojis.json
  {
    emoji = '✨',
    description = 'Introduce new features.',
  },
  -- It can define unofficials
  {
    emoji = '❤️',
    description = 'Fix bug (happy).',
  },
  -- It also can define non-emojis
  {
    emoji = '[ci]',
    description = 'Skip CI.',
  },
}

return E
