{
  pkgs,
  stdenvNoCC,
  lib,
}:
let
  pkgsCross =
    pkgs.pkgsCross.${
      if stdenvNoCC.buildPlatform.isAarch64 then "gnu64" else "aarch64-multiplatform"
    }.__splicedPackages;
  tests = [
    ({
      name = "spliceSingle";
      expr = (pkgsCross.splice { drv = pkgsCross.zsh; }).__spliced == pkgsCross.zsh.__spliced;
      expected = true;
    })
    ({
      name = "spliceSingleOverride";
      expr =
        (pkgsCross.splice { drv = pkgsCross.zsh.override { pcre2 = pkgsCross.pcre-cpp; }; })
        == (pkgsCross.zsh.override { pcre2 = pkgsCross.pcre-cpp; });
      expected = true;
    })
  ];
in
{
  test-splicing = stdenvNoCC.mkDerivation {
    name = "test-splicing";
    passthru = {
      inherit tests;
    };
    buildCommand =
      ''
        touch $out
      ''
      + lib.concatMapStringsSep "\n" (
        t:
        "([[ ${lib.boolToString t.expr} == ${lib.boolToString t.expected} ]] && echo '${t.name} success') || (echo '${t.name} fail' && exit 1)"
      ) tests;
  };
}
