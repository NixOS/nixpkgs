{ lib, stdenv, poetryLib }: python:
let
  inherit (poetryLib) ireplace;

  targetMachine = poetryLib.getTargetMachine stdenv;

  # Like builtins.substring but with stop being offset instead of length
  substr = start: stop: s: builtins.substring start (stop - start) s;

  # Strip leading/trailing whitespace from string
  stripStr = s: lib.elemAt (builtins.split "^ *" (lib.elemAt (builtins.split " *$" s) 0)) 2;
  findSubExpressionsFun = acc: c: (
    if c == "(" then
      (
        let
          posNew = acc.pos + 1;
          isOpen = acc.openP == 0;
          startPos = if isOpen then posNew else acc.startPos;
        in
        acc // {
          inherit startPos;
          exprs = acc.exprs ++ [ (substr acc.exprPos (acc.pos - 1) acc.expr) ];
          pos = posNew;
          openP = acc.openP + 1;
        }
      ) else if c == ")" then
      (
        let
          openP = acc.openP - 1;
          exprs = findSubExpressions (substr acc.startPos acc.pos acc.expr);
        in
        acc // {
          inherit openP;
          pos = acc.pos + 1;
          exprs = if openP == 0 then acc.exprs ++ [ exprs ] else acc.exprs;
          exprPos = if openP == 0 then acc.pos + 1 else acc.exprPos;
        }
      ) else acc // { pos = acc.pos + 1; }
  );

  # Make a tree out of expression groups (parens)
  findSubExpressions = expr':
    let
      expr = " " + expr';
      acc = builtins.foldl'
        findSubExpressionsFun
        {
          exprs = [ ];
          expr = expr;
          pos = 0;
          openP = 0;
          exprPos = 0;
          startPos = 0;
        }
        (lib.stringToCharacters expr);
      tailExpr = (substr acc.exprPos acc.pos expr);
      tailExprs = if tailExpr != "" then [ tailExpr ] else [ ];
    in
    acc.exprs ++ tailExprs;
  parseExpressions = exprs:
    let
      splitCond = (
        s: builtins.map
          (x: stripStr (if builtins.typeOf x == "list" then (builtins.elemAt x 0) else x))
          (builtins.split " (and|or) " (s + " "))
      );
      mapfn = expr: (
        if (builtins.match "^ ?$" expr != null) then null  # Filter empty
        else if (builtins.elem expr [ "and" "or" ]) then {
          type = "bool";
          value = expr;
        }
        else {
          type = "expr";
          value = expr;
        }
      );
      parse = expr: builtins.filter (x: x != null) (builtins.map mapfn (splitCond expr));
    in
    builtins.foldl'
      (
        acc: v: acc ++ (if builtins.typeOf v == "string" then parse v else [ (parseExpressions v) ])
      ) [ ]
      exprs;

  # Transform individual expressions to structured expressions
  # This function also performs variable substitution, replacing environment markers with their explicit values
  transformExpressions = exprs:
    let
      variables = {
        os_name = (
          if python.pname == "jython" then "java"
          else "posix"
        );
        sys_platform = (
          if stdenv.isLinux then "linux"
          else if stdenv.isDarwin then "darwin"
          else throw "Unsupported platform"
        );
        platform_machine = targetMachine;
        platform_python_implementation =
          let
            impl = python.passthru.implementation;
          in
          (
            if impl == "cpython" then "CPython"
            else if impl == "pypy" then "PyPy"
            else throw "Unsupported implementation ${impl}"
          );
        platform_release = ""; # Field not reproducible
        platform_system = (
          if stdenv.isLinux then "Linux"
          else if stdenv.isDarwin then "Darwin"
          else throw "Unsupported platform"
        );
        platform_version = ""; # Field not reproducible
        python_version = python.passthru.pythonVersion;
        python_full_version = python.version;
        implementation_name = python.implementation;
        implementation_version = python.version;
        # extra = "";
      };
      substituteVar = value: if builtins.hasAttr value variables then (builtins.toJSON variables."${value}") else value;
      processVar = value: builtins.foldl' (acc: v: v acc) value [
        stripStr
        substituteVar
      ];
    in
    if builtins.typeOf exprs == "set" then
      (
        if exprs.type == "expr" then
          (
            let
              mVal = ''[a-zA-Z0-9\'"_\. \-]+'';
              mOp = "in|[!=<>]+";
              e = stripStr exprs.value;
              m' = builtins.match ''^(${mVal}) +(${mOp}) *(${mVal})$'' e;
              m = builtins.map stripStr (if m' != null then m' else builtins.match ''^(${mVal}) +(${mOp}) *(${mVal})$'' e);
              m0 = processVar (builtins.elemAt m 0);
              m2 = processVar (builtins.elemAt m 2);
            in
            {
              type = "expr";
              value = {
                # HACK: We don't know extra at eval time, so we assume the expression is always true
                op = if m0 == "extra" then "true" else builtins.elemAt m 1;
                values = [ m0 m2 ];
              };
            }
          ) else exprs
      ) else builtins.map transformExpressions exprs;

  # Recursively eval all expressions
  evalExpressions = exprs:
    let
      unmarshal = v: (
        # TODO: Handle single quoted values
        if v == "True" then true
        else if v == "False" then false
        else builtins.fromJSON v
      );
      hasElem = needle: haystack: builtins.elem needle (builtins.filter (x: builtins.typeOf x == "string") (builtins.split " " haystack));
      op = {
        "true" = x: y: true;
        "<=" = x: y: op.">=" y x;
        "<" = x: y: lib.versionOlder (unmarshal x) (unmarshal y);
        "!=" = x: y: x != y;
        "==" = x: y: x == y;
        ">=" = x: y: lib.versionAtLeast (unmarshal x) (unmarshal y);
        ">" = x: y: op."<" y x;
        "~=" = v: c:
          let
            parts = builtins.splitVersion c;
            pruned = lib.take ((builtins.length parts) - 1) parts;
            upper = builtins.toString (
              (lib.toInt (builtins.elemAt pruned (builtins.length pruned - 1))) + 1
            );
            upperConstraint = builtins.concatStringsSep "." (ireplace (builtins.length pruned - 1) upper pruned);
          in
          op.">=" v c && op."<" v upperConstraint;
        "===" = x: y: x == y;
        "in" = x: y:
          let
            values = builtins.filter (x: builtins.typeOf x == "string") (builtins.split " " (unmarshal y));
          in
          builtins.elem (unmarshal x) values;
      };
    in
    if builtins.typeOf exprs == "set" then
      (
        if exprs.type == "expr" then
          (
            let
              expr = exprs;
              result = (op."${expr.value.op}") (builtins.elemAt expr.value.values 0) (builtins.elemAt expr.value.values 1);
            in
            {
              type = "value";
              value = result;
            }
          ) else exprs
      ) else builtins.map evalExpressions exprs;

  # Now that we have performed an eval all that's left to do is to concat the graph into a single bool
  reduceExpressions = exprs:
    let
      cond = {
        "and" = x: y: x && y;
        "or" = x: y: x || y;
      };
      reduceExpressionsFun = acc: v: (
        if builtins.typeOf v == "set" then
          (
            if v.type == "value" then
              (
                acc // {
                  value = cond."${acc.cond}" acc.value v.value;
                }
              ) else if v.type == "bool" then
              (
                acc // {
                  cond = v.value;
                }
              ) else throw "Unsupported type"
          ) else if builtins.typeOf v == "list" then
          (
            let
              ret = builtins.foldl'
                reduceExpressionsFun
                {
                  value = true;
                  cond = "and";
                }
                v;
            in
            acc // {
              value = cond."${acc.cond}" acc.value ret.value;
            }
          ) else throw "Unsupported type"
      );
    in
    (
      builtins.foldl'
        reduceExpressionsFun
        {
          value = true;
          cond = "and";
        }
        exprs
    ).value;
in
e: builtins.foldl' (acc: v: v acc) e [
  findSubExpressions
  parseExpressions
  transformExpressions
  evalExpressions
  reduceExpressions
]
