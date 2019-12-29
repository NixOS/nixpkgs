{ lib }:

let
  inherit (builtins) elemAt match;

  # Replace a list entry at defined index with set value
  ireplace = idx: value: list: let
    inherit (builtins) genList length;
  in
    genList (i: if i == idx then value else (elemAt list i)) (length list);

  operators = let
    matchWildCard = s: match "([^\*])(\.[\*])" s;
    mkComparison = ret: version: v: builtins.compareVersions version v == ret;
    mkIdxComparison = idx: version: v: let
      ver = builtins.splitVersion v;
      minor = builtins.toString (lib.toInt (elemAt ver idx) + 1);
      upper = builtins.concatStringsSep "." (ireplace idx minor ver);
    in
      operators.">=" version v && operators."<" version upper;
    dropWildcardPrecision = f: version: constraint: let
      m = matchWildCard constraint;
      hasWildcard = m != null;
      c = if hasWildcard then (elemAt m 0) else constraint;
      v =
        if hasWildcard then (builtins.substring 0 (builtins.stringLength c) version)
        else version;
    in
      f v c;
  in
    {
      # Prefix operators
      "==" = dropWildcardPrecision (mkComparison 0);
      ">" = dropWildcardPrecision (mkComparison 1);
      "<" = dropWildcardPrecision (mkComparison (-1));
      "!=" = v: c: ! operators."==" v c;
      ">=" = v: c: operators."==" v c || operators.">" v c;
      "<=" = v: c: operators."==" v c || operators."<" v c;
      # Semver specific operators
      "~" = mkIdxComparison 1; #
      "^" = mkIdxComparison 0;
      # Infix operators
      "-" = version: v: operators.">=" version v.vl && operators."<=" version v.vu;
    };

  re = {
    operators = "([=><!~\^]+)";
    version = "([0-9\.\*x]+)";
  };

  parseConstraint = constraint: let
    constraintStr = builtins.replaceStrings [ " " ] [ "" ] constraint;
    # The common prefix operators
    mPre = match "${re.operators} *${re.version}" constraintStr;
    # There is also an infix operator to match ranges
    mIn = match "${re.version} *(-) *${re.version}" constraintStr;
  in
    (
      if mPre != null then {
        op = elemAt mPre 0;
        v = elemAt mPre 1;
      }
        # Infix operators are range matches
      else if mIn != null then {
        op = elemAt mIn 1;
        v = {
          vl = (elemAt mIn 0);
          vu = (elemAt mIn 2);
        };
      }
      else throw "Constraint \"${constraintStr}\" could not be parsed"
    );

  satisfiesSemver = version: constraint: let
    inherit (parseConstraint constraint) op v;
  in
    if constraint == "*" then true else operators."${op}" version v;

in
{ inherit satisfiesSemver; }
