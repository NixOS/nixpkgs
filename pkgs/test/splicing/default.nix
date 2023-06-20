{ pkgs, stdenvNoCC, lib, }:
let
  pkgsCross = pkgs.pkgsCross.aarch64-multiplatform.__splicedPackages;
  tests =
    let
      pythonInNativeBuildInputs = lib.elemAt pkgsCross.python3Packages.xpybutil.nativeBuildInputs 0;
      overridenAttr = pkgsCross.hello.overrideAttrs (_: { something = "hello"; });
    in
    [
      ({
        name = "pythonInNativeBuildInputsShouldBeNative";
        expr = pythonInNativeBuildInputs.stdenv.hostPlatform.system == "x86_64-linux";
        expected = true;
      })
      ({
        name = "overridenAttrShouldHaveSplicedAndSomething";
        expr = if overridenAttr ? __spliced then overridenAttr.something == overridenAttr.__spliced.buildHost.something else false;
        expected = true;
      })
      ({
        name = "splicedShouldBeOverriden";
        expr = pkgsCross.nix.aws-sdk-cpp.cmakeFlags == pkgsCross.nix.aws-sdk-cpp.__spliced.hostTarget.cmakeFlags;
        expected = true;
      })
      ({
        name = "notCrossOverriden";
        expr = (pkgs.hello.overrideAttrs (_: _: { passthru = { o = "works"; }; })) ? o;
        expected = true;
      })
    ];
in
{
  test-splicing = stdenvNoCC.mkDerivation {
    name = "test-splicing";
    passthru = { inherit tests; };
    buildCommand = ''
      touch $out
    '' + lib.concatMapStringsSep "\n" (t: "([[ ${lib.boolToString t.expr} == ${lib.boolToString t.expected} ]] && echo '${t.name} success') || (echo '${t.name} fail' && exit 1)") tests;
  };
}
