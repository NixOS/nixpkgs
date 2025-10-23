# To run these tests:
# nix-build -A tests.stdenv

{
  stdenv,
  pkgs,
  lib,
  testers,
}:

let
  # early enough not to rebuild gcc but late enough to have patchelf
  earlyPkgs = stdenv.__bootPackages.stdenv.__bootPackages;
  earlierPkgs =
    stdenv.__bootPackages.stdenv.__bootPackages.stdenv.__bootPackages.stdenv.__bootPackages.stdenv.__bootPackages;
  # use a early stdenv so when hacking on stdenv this test can be run quickly
  bootStdenv =
    stdenv.__bootPackages.stdenv.__bootPackages.stdenv.__bootPackages.stdenv.__bootPackages.stdenv;
  pkgsStructured = import pkgs.path {
    config = {
      structuredAttrsByDefault = true;
    };
    inherit (stdenv.hostPlatform) system;
  };
  bootStdenvStructuredAttrsByDefault =
    pkgsStructured.stdenv.__bootPackages.stdenv.__bootPackages.stdenv.__bootPackages.stdenv.__bootPackages.stdenv;

  runCommand = earlierPkgs.runCommand;

  ccWrapperSubstitutionsTest =
    {
      name,
      stdenv',
      extraAttrs ? { },
    }:

    stdenv'.cc.overrideAttrs (
      previousAttrs:
      (
        {
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
        }
        // extraAttrs
      )
    );

  testEnvAttrset =
    {
      name,
      stdenv',
      extraAttrs ? { },
    }:
    stdenv'.mkDerivation (
      {
        inherit name;
        env = {
          string = "testing-string";
        };

        passAsFile = [ "buildCommand" ];
        buildCommand = ''
          declare -p string
          echo "env.string = $string"
          [[ $string == "testing-string" ]] || (echo "'\$string' was not 'testing-string'" && false)
          [[ "$(declare -p string)" == 'declare -x string="testing-string"' ]] || (echo "'\$string' was not exported" && false)
          touch $out
        '';
      }
      // extraAttrs
    );

  testPrependAndAppendToVar =
    {
      name,
      stdenv',
      extraAttrs ? { },
    }:
    stdenv'.mkDerivation (
      {
        inherit name;
        env = {
          string = "testing-string";
        };

        passAsFile = [ "buildCommand" ] ++ lib.optionals (extraAttrs ? extraTest) [ "extraTest" ];
        buildCommand = ''
          declare -p string
          appendToVar string hello
          # test that quoted strings work
          prependToVar string "world"
          declare -p string

          declare -A associativeArray=(["X"]="Y")
          [[ $(appendToVar associativeArray "fail" 2>&1) =~ "trying to use" ]] || (echo "appendToVar did not throw appending to associativeArray" && false)
          [[ $(prependToVar associativeArray "fail" 2>&1) =~ "trying to use" ]] || (echo "prependToVar did not throw prepending associativeArray" && false)

          [[ $string == "world testing-string hello" ]] || (echo "'\$string' was not 'world testing-string hello'" && false)

          # test appending to a unset variable
          appendToVar nonExistant created hello
          declare -p nonExistant
          if [[ -n $__structuredAttrs ]]; then
            [[ "''${nonExistant[@]}" == "created hello" ]]
          else
            # there's a extra " " in front here and a extra " " in the end of prependToVar
            # shouldn't matter because these functions will mostly be used for $*Flags and the Flag variable will in most cases already exist
            [[ "$nonExistant" == " created hello" ]]
          fi

          eval "$extraTest"

          touch $out
        '';
      }
      // extraAttrs
    );

  testConcatTo =
    {
      name,
      stdenv',
      extraAttrs ? { },
    }:
    stdenv'.mkDerivation (
      {
        inherit name;

        string = "a *";
        list = [
          "c"
          "d"
        ];

        passAsFile = [ "buildCommand" ] ++ lib.optionals (extraAttrs ? extraTest) [ "extraTest" ];
        buildCommand = ''
          declare -A associativeArray=(["X"]="Y")
          [[ $(concatTo nowhere associativeArray 2>&1) =~ "trying to use" ]] || (echo "concatTo did not throw concatenating associativeArray" && false)

          empty_array=()
          empty_string=""

          declare -a flagsArray
          concatTo flagsArray string list notset=e=f empty_array=g empty_string=h
          declare -p flagsArray
          [[ "''${flagsArray[0]}" == "a" ]] || (echo "'\$flagsArray[0]' was not 'a'" && false)
          [[ "''${flagsArray[1]}" == "*" ]] || (echo "'\$flagsArray[1]' was not '*'" && false)
          [[ "''${flagsArray[2]}" == "c" ]] || (echo "'\$flagsArray[2]' was not 'c'" && false)
          [[ "''${flagsArray[3]}" == "d" ]] || (echo "'\$flagsArray[3]' was not 'd'" && false)
          [[ "''${flagsArray[4]}" == "e=f" ]] || (echo "'\$flagsArray[4]' was not 'e=f'" && false)
          [[ "''${flagsArray[5]}" == "g" ]] || (echo "'\$flagsArray[5]' was not 'g'" && false)
          [[ "''${flagsArray[6]}" == "h" ]] || (echo "'\$flagsArray[6]' was not 'h'" && false)

          # test concatenating to unset variable
          concatTo nonExistant string list notset=e=f empty_array=g empty_string=h
          declare -p nonExistant
          [[ "''${nonExistant[0]}" == "a" ]] || (echo "'\$nonExistant[0]' was not 'a'" && false)
          [[ "''${nonExistant[1]}" == "*" ]] || (echo "'\$nonExistant[1]' was not '*'" && false)
          [[ "''${nonExistant[2]}" == "c" ]] || (echo "'\$nonExistant[2]' was not 'c'" && false)
          [[ "''${nonExistant[3]}" == "d" ]] || (echo "'\$nonExistant[3]' was not 'd'" && false)
          [[ "''${nonExistant[4]}" == "e=f" ]] || (echo "'\$nonExistant[4]' was not 'e=f'" && false)
          [[ "''${nonExistant[5]}" == "g" ]] || (echo "'\$nonExistant[5]' was not 'g'" && false)
          [[ "''${nonExistant[6]}" == "h" ]] || (echo "'\$nonExistant[6]' was not 'h'" && false)

          eval "$extraTest"

          touch $out
        '';
      }
      // extraAttrs
    );

  testConcatStringsSep =
    { name, stdenv' }:
    stdenv'.mkDerivation {
      inherit name;

      # NOTE: Testing with "&" as separator is intentional, because unquoted
      # "&" has a special meaning in the "${var//pattern/replacement}" syntax.
      # Cf. https://github.com/NixOS/nixpkgs/pull/318614#discussion_r1706191919
      passAsFile = [ "buildCommand" ];
      buildCommand = ''
        declare -A associativeArray=(["X"]="Y")
        [[ $(concatStringsSep ";" associativeArray 2>&1) =~ "trying to use" ]] || (echo "concatStringsSep did not throw concatenating associativeArray" && false)

        string="lorem ipsum dolor sit amet"
        stringWithSep="$(concatStringsSep "&" string)"
        [[ "$stringWithSep" == "lorem&ipsum&dolor&sit&amet" ]] || (echo "'\$stringWithSep' was not 'lorem&ipsum&dolor&sit&amet'" && false)

        array=("lorem ipsum" "dolor" "sit amet")
        arrayWithSep="$(concatStringsSep "&" array)"
        [[ "$arrayWithSep" == "lorem ipsum&dolor&sit amet" ]] || (echo "'\$arrayWithSep' was not 'lorem ipsum&dolor&sit amet'" && false)

        array=("lorem ipsum" "dolor" "sit amet")
        arrayWithSep="$(concatStringsSep "++" array)"
        [[ "$arrayWithSep" == "lorem ipsum++dolor++sit amet" ]] || (echo "'\$arrayWithSep' was not 'lorem ipsum++dolor++sit amet'" && false)

        array=("lorem ipsum" "dolor" "sit amet")
        arrayWithSep="$(concatStringsSep " and " array)"
        [[ "$arrayWithSep" == "lorem ipsum and dolor and sit amet" ]] || (echo "'\$arrayWithSep' was not 'lorem ipsum and dolor and sit amet'" && false)

        touch $out
      '';
    };
in

{
  # tests for hooks in `stdenv.defaultNativeBuildInputs`
  hooks = lib.recurseIntoAttrs (
    import ./hooks.nix {
      stdenv = bootStdenv;
      pkgs = earlyPkgs;
      inherit lib;
    }
  );

  outputs-no-out =
    runCommand "outputs-no-out-assert"
      {
        result = earlierPkgs.testers.testBuildFailure (
          bootStdenv.mkDerivation {
            NIX_DEBUG = 1;
            name = "outputs-no-out";
            outputs = [ "foo" ];
            buildPhase = ":";
            installPhase = ''
              touch $foo
            '';
          }
        );

        # Assumption: the first output* variable to be configured is
        #   _overrideFirst outputDev "dev" "out"
        expectedMsg = "error: _assignFirst: could not find a non-empty variable whose name to assign to outputDev.\n       The following variables were all unset or empty:\n           dev out";
      }
      ''
        grep -F "$expectedMsg" $result/testBuildFailure.log >/dev/null
        touch $out
      '';

  test-env-attrset = testEnvAttrset {
    name = "test-env-attrset";
    stdenv' = bootStdenv;
  };

  # Check that mkDerivation rejects MD5 hashes
  rejectedHashes = lib.recurseIntoAttrs {
    md5 =
      let
        drv = runCommand "md5 outputHash rejected" {
          outputHash = "md5-fPt7dxVVP7ffY3MxkQdwVw==";
        } "true";
      in
      assert !(builtins.tryEval drv).success;
      { };
  };

  test-inputDerivation =
    let
      inherit
        (stdenv.mkDerivation {
          dep1 = derivation {
            name = "dep1";
            builder = "/bin/sh";
            args = [
              "-c"
              ": > $out"
            ];
            inherit (stdenv.buildPlatform) system;
          };
          dep2 = derivation {
            name = "dep2";
            builder = "/bin/sh";
            args = [
              "-c"
              ": > $out"
            ];
            inherit (stdenv.buildPlatform) system;
          };
          passAsFile = [ "dep2" ];
        })
        inputDerivation
        ;
    in
    runCommand "test-inputDerivation"
      {
        exportReferencesGraph = [
          "graph"
          inputDerivation
        ];
      }
      ''
        grep ${inputDerivation.dep1} graph
        grep ${inputDerivation.dep2} graph
        touch $out
      '';

  test-inputDerivation-fixed-output =
    let
      inherit
        (stdenv.mkDerivation {
          dep1 = derivation {
            name = "dep1";
            builder = "/bin/sh";
            args = [
              "-c"
              ": > $out"
            ];
            inherit (stdenv.buildPlatform) system;
          };
          dep2 = derivation {
            name = "dep2";
            builder = "/bin/sh";
            args = [
              "-c"
              ": > $out"
            ];
            inherit (stdenv.buildPlatform) system;
          };
          name = "meow";
          outputHash = "sha256-47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=";
          outputHashMode = "flat";
          outputHashAlgo = "sha256";
          buildCommand = ''
            touch $out
          '';
          passAsFile = [ "dep2" ];
        })
        inputDerivation
        ;
    in
    runCommand "test-inputDerivation"
      {
        exportReferencesGraph = [
          "graph"
          inputDerivation
        ];
      }
      ''
        grep ${inputDerivation.dep1} graph
        grep ${inputDerivation.dep2} graph
        touch $out
      '';

  test-prepend-append-to-var = testPrependAndAppendToVar {
    name = "test-prepend-append-to-var";
    stdenv' = bootStdenv;
  };

  test-concat-to = testConcatTo {
    name = "test-concat-to";
    stdenv' = bootStdenv;
  };

  test-concat-strings-sep = testConcatStringsSep {
    name = "test-concat-strings-sep";
    stdenv' = bootStdenv;
  };

  test-structured-env-attrset = testEnvAttrset {
    name = "test-structured-env-attrset";
    stdenv' = bootStdenv;
    extraAttrs = {
      __structuredAttrs = true;
    };
  };

  test-cc-wrapper-substitutions = ccWrapperSubstitutionsTest {
    name = "test-cc-wrapper-substitutions";
    stdenv' = bootStdenv;
  };

  ensure-no-execve-in-setup-sh =
    derivation {
      name = "ensure-no-execve-in-setup-sh";
      inherit (stdenv.hostPlatform) system;
      builder = "${stdenv.bootstrapTools}/bin/bash";
      PATH = "${pkgs.strace}/bin:${stdenv.bootstrapTools}/bin";
      initialPath = [
        stdenv.bootstrapTools
        pkgs.strace
      ];
      args = [
        "-c"
        ''
          countCall() {
            echo "$stats" | tr -s ' ' | grep "$1" | cut -d ' ' -f5
          }

          # prevent setup.sh from running `nproc` when cores=0
          # (this would mess up the syscall stats)
          export NIX_BUILD_CORES=1

          echo "Analyzing setup.sh with strace"
          stats=$(strace -fc bash -c ". ${../../stdenv/generic/setup.sh}" 2>&1)
          echo "$stats" | head -n15

          # fail if execve calls is > 1
          stats=$(strace -fc bash -c ". ${../../stdenv/generic/setup.sh}" 2>&1)
          execveCalls=$(countCall execve)
          if [ "$execveCalls" -gt 1 ]; then
            echo "execve calls: $execveCalls; expected: 1"
            echo "ERROR: setup.sh should not launch additional processes when being sourced"
            exit 1
          else
            echo "setup.sh doesn't launch extra processes when sourcing, as expected"
          fi

          touch $out
        ''
      ];
    }
    // {
      meta = { };
    };

  structuredAttrsByDefault = lib.recurseIntoAttrs {

    hooks = lib.recurseIntoAttrs (
      import ./hooks.nix {
        stdenv = bootStdenvStructuredAttrsByDefault;
        pkgs = earlyPkgs;
        inherit lib;
      }
    );

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
        list = [
          "a"
          "b"
        ];
        # will be a bash associative array(dictionary) in attrs.sh
        # declare -A array=(['a']='1' ['b']='2' )
        # and a json object in attrs.json
        # {"array":{"a":"1","b":"2"}
        array = {
          a = "1";
          b = "2";
        };
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

    test-concat-to = testConcatTo {
      name = "test-concat-to-structuredAttrsByDefault";
      stdenv' = bootStdenvStructuredAttrsByDefault;
      extraAttrs = {
        # test that whitespace is kept in the bash array for structuredAttrs
        listWithSpaces = [
          "c c"
          "d d"
        ];
        extraTest = ''
          declare -a flagsWithSpaces
          concatTo flagsWithSpaces string listWithSpaces
          declare -p flagsWithSpaces
          [[ "''${flagsWithSpaces[0]}" == "a" ]] || (echo "'\$flagsWithSpaces[0]' was not 'a'" && false)
          [[ "''${flagsWithSpaces[1]}" == "*" ]] || (echo "'\$flagsWithSpaces[1]' was not '*'" && false)
          [[ "''${flagsWithSpaces[2]}" == "c c" ]] || (echo "'\$flagsWithSpaces[2]' was not 'c c'" && false)
          [[ "''${flagsWithSpaces[3]}" == "d d" ]] || (echo "'\$flagsWithSpaces[3]' was not 'd d'" && false)
        '';
      };
    };

    test-concat-strings-sep = testConcatStringsSep {
      name = "test-concat-strings-sep-structuredAttrsByDefault";
      stdenv' = bootStdenvStructuredAttrsByDefault;
    };

    test-golden-example-structuredAttrs =
      let
        goldenSh = earlyPkgs.writeText "goldenSh" ''
          declare -A EXAMPLE_ATTRS=(['foo']='bar' )
          declare EXAMPLE_BOOL_FALSE=
          declare EXAMPLE_BOOL_TRUE=1
          declare EXAMPLE_INT=123
          declare EXAMPLE_INT_NEG=-123
          declare -a EXAMPLE_LIST=('foo' 'bar' )
          declare EXAMPLE_STR='foo bar'
        '';
        goldenJson = earlyPkgs.writeText "goldenSh" ''
          {
            "EXAMPLE_ATTRS": {
              "foo": "bar"
            },
            "EXAMPLE_BOOL_FALSE": false,
            "EXAMPLE_BOOL_TRUE": true,
            "EXAMPLE_INT": 123,
            "EXAMPLE_INT_NEG": -123,
            "EXAMPLE_LIST": [
              "foo",
              "bar"
            ],
            "EXAMPLE_NESTED_ATTRS": {
              "foo": {
                "bar": "baz"
              }
            },
            "EXAMPLE_NESTED_LIST": [
              [
                "foo",
                "bar"
              ],
              [
                "baz"
              ]
            ],
            "EXAMPLE_STR": "foo bar"
          }
        '';
      in
      bootStdenvStructuredAttrsByDefault.mkDerivation {
        name = "test-golden-example-structuredAttrsByDefault";
        nativeBuildInputs = [ earlyPkgs.jq ];

        EXAMPLE_BOOL_TRUE = true;
        EXAMPLE_BOOL_FALSE = false;
        EXAMPLE_INT = 123;
        EXAMPLE_INT_NEG = -123;
        EXAMPLE_STR = "foo bar";
        EXAMPLE_LIST = [
          "foo"
          "bar"
        ];
        EXAMPLE_NESTED_LIST = [
          [
            "foo"
            "bar"
          ]
          [ "baz" ]
        ];
        EXAMPLE_ATTRS = {
          foo = "bar";
        };
        EXAMPLE_NESTED_ATTRS = {
          foo.bar = "baz";
        };

        inherit goldenSh;
        inherit goldenJson;

        buildCommand = ''
          mkdir -p $out
          cat $NIX_ATTRS_SH_FILE | grep "EXAMPLE" | grep -v -E 'installPhase|jq' > $out/sh
          jq 'with_entries(select(.key|match("EXAMPLE")))' $NIX_ATTRS_JSON_FILE > $out/json
          diff $out/sh $goldenSh
          diff $out/json $goldenJson
        '';
      };
  };
}
