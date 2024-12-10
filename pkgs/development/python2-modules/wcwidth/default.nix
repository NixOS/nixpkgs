{
  backports-functools-lru-cache,
  wcwidth,
}:

wcwidth.overridePythonAttrs (oldAttrs: {
  propagatedBuildInputs = oldAttrs.propagatedBuildInputs or [ ] ++ [
    backports-functools-lru-cache
  ];
})
