with builtins;
let
  /*
  underTest = {
    x = {
      a = 1;
      b = "2";
    };
  };

  tests = [
    (root: false)
    {
      x = [
        (set: true)
        {
          a = (a: a > 1);
          b = (b: b == "3");
        }
      ];
    }
  ];

  results = run "Examples" underTest tests;
  */

  passed = desc: {
    result = "pass";
    description = desc;
  };

  failed = desc: {
    result = "failed";
    description = desc;
  };

  prefixName = name: res: {
    inherit (res) result;
    description = "${name}: ${res.description}";
  };

  run = name: under: tests: if isList tests then
    (concatLists (map (run name under) tests))
  else if isAttrs tests then
    (concatLists (map (
    subName: run (name + "." + subName) (if hasAttr subName under then getAttr subName under else "<MISSING!>") (getAttr subName tests)
    ) (attrNames tests)))
  else if isFunction tests then
    let
      res = tests under;
    in
      if isBool res then
        [
          (prefixName name (if tests under then passed "passed" else failed "failed"))
        ]
      else
        [ (prefixName name res) ]
  else [
    failed (name ": not a function, list or set")
  ];
in
  { inherit run passed failed; }
