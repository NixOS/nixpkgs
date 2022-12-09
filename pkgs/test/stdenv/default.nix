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
        [[ $wrapperName == "CC_WRAPPER" ]] || (echo "'\$wrapperName' was not 'CC_WRAPPER'" && false)
        declare -p suffixSalt
        echo "env.suffixSalt = $suffixSalt"
        [[ $suffixSalt == "${stdenv'.cc.suffixSalt}" ]] || (echo "'\$suffxSalt' was not '${stdenv'.cc.suffixSalt}'" && false)

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
          [[ $string == "testing-string" ]] || (echo "'\$string' was not 'testing-string'" && false)
          touch $out
        '';
      } // extraAttrs);

  testPrependAndAppendToVar = { name, stdenv', extraAttrs ? { } }:
    stdenv'.mkDerivation
      ({
        inherit name;
        env = {
          string = "testing-string";
        };

        passAsFile = [ "buildCommand" ] ++ lib.optionals (extraAttrs ? extraTest) [ "extraTest" ];
        # FIXME: with structuredAttrs string is converted to a indexed array
        # should a/pToVar check if the passed variable is a array or a string?
        # declare -x string="testing-string"
        # declare -ax string=([0]="world" [1]="testing-string" [2]="hello")
        buildCommand = ''
          declare -p string
          appendToVar string hello
          # test that quoted strings work
          prependToVar string "world"
          declare -p string

          [[ $string == "world testing-string hello" ]] || (echo "'\$string' was not 'world testing-string hello'" && false)

          eval "$extraTest"

          touch $out
        '';
      } // extraAttrs);

in

{
  test-env-attrset = testEnvAttrset { name = "test-env-attrset"; stdenv' = bootStdenv; };

  test-prepend-append-to-var = testPrependAndAppendToVar {
    name = "test-prepend-append-to-var";
    stdenv' = bootStdenv;
  };

  test-structured-env-attrset = testEnvAttrset {
    name = "test-structured-env-attrset";
    stdenv' = bootStdenv;
    extraAttrs = { __structuredAttrs = true; };
  };

  test-cc-wrapper-substitutions = ccWrapperSubstitutionsTest {
    name = "test-cc-wrapper-substitutions";
    stdenv' = bootStdenv;
  };

  structuredAttrsByDefault = lib.recurseIntoAttrs {
    test-cc-wrapper-substitutions = ccWrapperSubstitutionsTest {
      name = "test-cc-wrapper-substitutions-structuredAttrsByDefault";
      stdenv' = bootStdenvStructuredAttrsByDefault;
    };

    test-structured-env-attrset = testEnvAttrset {
      name = "test-structured-env-attrset-structuredAttrsByDefault";
      stdenv' = bootStdenvStructuredAttrsByDefault;
    };

    test-prepend-append-to-var = testPrependAndAppendToVar {
      name = "test-prepend-append-to-var-structuredAttrsByDefault";
      stdenv' = bootStdenvStructuredAttrsByDefault;
      extraAttrs = {
        # will be a bash indexed array in attrs.sh
        # declare -a list=('a' 'b' )
        # and a json array in attrs.json
        # "list":["a","b"]
        list = [ "a" "b" ];
        # will be a bash associative array(dictionary) in attrs.sh
        # declare -A array=(['a']='1' ['b']='2' )
        # and a json object in attrs.json
        # {"array":{"a":"1","b":"2"}
        array = { a = "1"; b = "2"; };
        extraTest = ''
          declare -p array
          array+=(["c"]="3")
          declare -p array

          [[ "''${array[c]}" == "3" ]] || (echo "c element of '\$array' was not '3'" && false)

          declare -p list
          prependToVar list hello
          # test that quoted strings work
          appendToVar list "world"
          declare -p list

          [[ "''${list[0]}" == "hello" ]] || (echo "first element of '\$list' was not 'hello'" && false)
          [[ "''${list[1]}" == "a" ]] || (echo "first element of '\$list' was not 'a'" && false)
          [[ "''${list[-1]}" == "world" ]] || (echo "last element of '\$list' was not 'world'" && false)
        '';
      };
    };
  };
}
