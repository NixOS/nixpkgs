{ backports-functools-lru-cache
, wcwidth
}:

wcwidth.overridePythonAttrs(oldAttrs: {
  propagatedBuildInputs = oldAttrs.propagatedBuildInputs ++ [
    backports-functools-lru-cache
  ];
})

