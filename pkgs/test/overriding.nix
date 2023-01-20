{ lib, pkgs, stdenvNoCC }:

let
  tests =
    let
      p = pkgs.python3Packages.xpybutil.overridePythonAttrs (_: { dontWrapPythonPrograms = true; });
    in
    [
      ({
        name = "overridePythonAttrs";
        expr = !lib.hasInfix "wrapPythonPrograms" p.postFixup;
        expected = true;
      })
    ];
in

stdenvNoCC.mkDerivation {
  name = "test-overriding";
  passthru = { inherit tests; };
  buildCommand = ''
    touch $out
  '' + lib.concatMapStringsSep "\n" (t: "([[ ${lib.boolToString t.expr} == ${lib.boolToString t.expected} ]] && echo '${t.name} success') || (echo '${t.name} fail' && exit 1)") tests;
}
