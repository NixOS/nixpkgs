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


  ccWrapperSubstitutionsTest = { name, stdenv', extraAttrs ? { } }:

    stdenv'.cc.overrideAttrs (previousAttrs: ({
      inherit name;

      postFixup = previousAttrs.postFixup + ''
        declare -p wrapperName
        echo "env.wrapperName = $wrapperName"
        [[ $wrapperName == "CC_WRAPPER" ]] || (echo "wrapperName was not CC_WRAPPER" && false)
        declare -p suffixSalt
        echo "env.suffixSalt = $suffixSalt"
        [[ $suffixSalt == "${stdenv'.cc.suffixSalt}" ]] || (echo "wrapperName was not ${stdenv'.cc.suffixSalt}" && false)

        grep -q "@out@" $out/bin/cc || echo "@out@ in $out/bin/cc was substituted"
        grep -q "@suffixSalt@" $out/bin/cc && (echo "$out/bin/cc contains unsubstituted variables" && false)

        touch $out
      '';
    } // extraAttrs));

  testEnvAttrset = { name, stdenv', extraAttrs ? { } }:
    stdenv'.mkDerivation
      ({
        inherit name;
        env = {
          string = "testing-string";
        };

        passAsFile = [ "buildCommand" ];
        buildCommand = ''
          declare -p string
          echo "env.string = $string"
          [[ $string == "testing-string" ]] || (echo "string was not testing-string" && false)
          touch $out
        '';
      } // extraAttrs);

in

{
  test-env-attrset = testEnvAttrset { name = "test-env-attrset"; stdenv' = bootStdenv; };

  test-structured-env-attrset = testEnvAttrset { name = "test-structured-env-attrset"; stdenv' = bootStdenv; extraAttrs = { __structuredAttrs = true; }; };

  test-cc-wrapper-substitutions = ccWrapperSubstitutionsTest { name = "test-cc-wrapper-substitutions"; stdenv' = bootStdenv; };

  structuredAttrsByDefault = lib.recurseIntoAttrs {
    test-cc-wrapper-substitutions = ccWrapperSubstitutionsTest { name = "test-cc-wrapper-substitutions-structuredAttrsByDefault"; stdenv' = bootStdenvStructuredAttrsByDefault; };

    test-structured-env-attrset = testEnvAttrset { name = "test-structured-env-attrset-structuredAttrsByDefault"; stdenv' = bootStdenvStructuredAttrsByDefault; };
  };
}
