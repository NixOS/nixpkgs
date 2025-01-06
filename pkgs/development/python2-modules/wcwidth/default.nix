{ backports-functools-lru-cache
, wcwidth
, lib
}:

wcwidth.overridePythonAttrs(oldAttrs: {
  propagatedBuildInputs = oldAttrs.propagatedBuildInputs or [] ++ [
    backports-functools-lru-cache
  ];

  /**
    As of version 0.2.13 upstream still supports python2. In the future, this
    package should be dropped or pinned to the last working version after the
    final release for python2. See:
      https://github.com/jquast/wcwidth/pull/117#issuecomment-1946609638
  */
  disabled = false;

  meta = oldAttrs.meta // {
    /** maintainers overridden here for python2; this makes sure that python3
        maintainers are not blamed for the breakage here. */
    maintainers = with lib.maintainers; [ bryango ];
  };
})
