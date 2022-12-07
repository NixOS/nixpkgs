# To run these tests:
# nix-build -A tests.stdenv

{ stdenv
, pkgs
, lib
,
}:

let
  # use a early stdenv so when hacking on stdenv this test can be run quickly
  bootStdenv = stdenv.__bootPackages.stdenv.__bootPackages.stdenv.__bootPackages.stdenv.__bootPackages.stdenv;
  pkgsStructured = import pkgs.path { config = { structuredAttrsByDefault = true; }; inherit (stdenv.hostPlatform) system; };
  bootStdenvStructuredAttrsByDefault = pkgsStructured.stdenv.__bootPackages.stdenv.__bootPackages.stdenv.__bootPackages.stdenv.__bootPackages.stdenv;
in

{
  test-env-attrset = bootStdenv.mkDerivation {
    name = "test-env-attrset";
    dontUnpack = true;
    dontConfigure = true;
    dontBuild = true;
    dontPatch = true;
    dontFixup = true;
    env = {
      string = "testing-string";
    };

    installPhase = ''
      declare -p string
      echo "env.string = $string"
      [[ $string == "testing-string" ]] || (echo "string was not testing-string" && false)
      touch $out
    '';
  };

  test-structured-env-attrset = bootStdenv.mkDerivation {
    name = "test-structured-env-attrset";
    dontUnpack = true;
    dontConfigure = true;
    dontBuild = true;
    dontPatch = true;
    dontFixup = true;
    __structuredAttrs = true;
    env = {
      string = "testing-string";
    };

    installPhase = ''
      declare -p string
      echo "env.string = $string"
      [[ $string == "testing-string" ]] || (echo "string was not testing-string" && false)
      touch $out
    '';
  };

  test-cc-wrapper-substitutions = bootStdenv.cc.overrideAttrs (previousAttrs: {
    name = "test-cc-wrapper-substitutions";

    postFixup = previousAttrs.postFixup + ''
      declare -p wrapperName
      echo "env.wrapperName = $wrapperName"
      [[ $wrapperName == "CC_WRAPPER" ]] || (echo "wrapperName was not CC_WRAPPER" && false)
      touch $out
    '';
  });

  structuredAttrsByDefault = lib.recurseIntoAttrs {

    test-cc-wrapper-substitutions = bootStdenvStructuredAttrsByDefault.cc.overrideAttrs (previousAttrs: {
      name = "test-cc-wrapper-substitutions-structuredAttrsByDefault";

      postFixup = previousAttrs.postFixup + ''
        declare -p wrapperName
        echo "env.wrapperName = $wrapperName"
        [[ $wrapperName == "CC_WRAPPER" ]] || (echo "wrapperName was not CC_WRAPPER" && false)
        declare -p suffixSalt
        echo "env.suffixSalt = $suffixSalt"
        [[ $suffixSalt == "${bootStdenvStructuredAttrsByDefault.cc.suffixSalt}" ]] || (echo "wrapperName was not ${bootStdenvStructuredAttrsByDefault.cc.suffixSalt}" && false)

        grep -q "@out@" $out/bin/cc || echo "@out@ in $out/bin/cc was substituted"
        grep -q "@suffixSalt@" $out/bin/cc && (echo "$out/bin/cc contains unsubstituted variables" && false)

        touch $out
      '';
    });

    test-structured-env-attrset = bootStdenvStructuredAttrsByDefault.mkDerivation {
      name = "test-structured-env-attrset-structuredAttrsByDefault";
      dontUnpack = true;
      dontConfigure = true;
      dontBuild = true;
      dontPatch = true;
      dontFixup = true;
      env = {
        string = "testing-string";
      };

      installPhase = ''
        declare -p string
        echo "env.string = $string"
        [[ $string == "testing-string" ]] || (echo "string was not testing-string" && false)
        touch $out
      '';
    };
  };
}
