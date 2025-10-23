{
  lib,
  stdenv,
  runCommand,
  runCommandWith,
  runCommandCC,
  writeText,
  bintools,
  hello,
  debian-devscripts,
}:

let
  # writeCBin from trivial-builders won't let us choose
  # our own stdenv
  writeCBinWithStdenv =
    codePath: stdenv': env:
    runCommandWith
      {
        name = "test-bin";
        stdenv = stdenv';
        derivationArgs = {
          inherit codePath;
          preferLocalBuild = true;
          allowSubstitutes = false;
        }
        // env;
      }
      ''
        [ -n "$postConfigure" ] && eval "$postConfigure"
        [ -n "$preBuild" ] && eval "$preBuild"
        n=$out/bin/test-bin
        mkdir -p "$(dirname "$n")"
        cp "$codePath" code.c
        NIX_DEBUG=1 $CC -x c code.c -O1 $TEST_EXTRA_FLAGS -o "$n"
      '';

  f1exampleWithStdEnv = writeCBinWithStdenv ./fortify1-example.c;
  f2exampleWithStdEnv = writeCBinWithStdenv ./fortify2-example.c;
  f3exampleWithStdEnv = writeCBinWithStdenv ./fortify3-example.c;

  flexArrF2ExampleWithStdEnv = writeCBinWithStdenv ./flex-arrays-fortify-example.c;

  checkGlibcxxassertionsWithStdEnv =
    expectDefined:
    writeCBinWithStdenv (
      writeText "main.cpp" ''
        #if${if expectDefined then "n" else ""}def _GLIBCXX_ASSERTIONS
        #error "Expected _GLIBCXX_ASSERTIONS to be ${if expectDefined then "" else "un"}defined"
        #endif
        int main() {}
      ''
    );

  # for when we need a slightly more complicated program
  helloWithStdEnv =
    stdenv': env:
    (hello.override { stdenv = stdenv'; }).overrideAttrs (
      {
        preBuild = ''
          export CFLAGS="$TEST_EXTRA_FLAGS"
        '';
        NIX_DEBUG = "1";
        postFixup = ''
          cp $out/bin/hello $out/bin/test-bin
        '';
      }
      // env
    );

  stdenvUnsupport =
    additionalUnsupported:
    stdenv.override {
      cc = stdenv.cc.override {
        cc = (
          lib.extendDerivation true rec {
            # this is ugly - have to cross-reference from
            # hardeningUnsupportedFlagsByTargetPlatform to hardeningUnsupportedFlags
            # because the finalAttrs mechanism that hardeningUnsupportedFlagsByTargetPlatform
            # implementations use to do this won't work with lib.extendDerivation.
            # but it's simplified by the fact that targetPlatform is already fixed
            # at this point.
            hardeningUnsupportedFlagsByTargetPlatform = _: hardeningUnsupportedFlags;
            hardeningUnsupportedFlags =
              (
                if stdenv.cc.cc ? hardeningUnsupportedFlagsByTargetPlatform then
                  stdenv.cc.cc.hardeningUnsupportedFlagsByTargetPlatform stdenv.targetPlatform
                else
                  (stdenv.cc.cc.hardeningUnsupportedFlags or [ ])
              )
              ++ additionalUnsupported;
          } stdenv.cc.cc
        );
      };
      allowedRequisites = null;
    };

  checkTestBin =
    testBin:
    {
      # can only test flags that are detectable by hardening-check
      ignoreBindNow ? true,
      ignoreFortify ? true,
      ignorePie ? true,
      ignoreRelRO ? true,
      ignoreStackProtector ? true,
      ignoreStackClashProtection ? true,
      expectFailure ? false,
    }:
    let
      stackClashStr = "Stack clash protection: yes";
      expectFailureClause = lib.optionalString expectFailure " && echo 'ERROR: Expected hardening-check to fail, but it passed!' >&2 && false";
    in
    runCommandCC "check-test-bin"
      {
        nativeBuildInputs = [ debian-devscripts ];
        buildInputs = [ testBin ];
        meta = {
          platforms =
            if ignoreStackClashProtection then
              lib.platforms.linux # ELF-reliant
            else
              [ "x86_64-linux" ]; # stackclashprotection test looks for x86-specific instructions
          # musl implementation of fortify undetectable by this means even if present,
          # static similarly
          broken = (stdenv.hostPlatform.isMusl || stdenv.hostPlatform.isStatic) && !ignoreFortify;
        };
      }
      (
        ''
          if ${lib.optionalString (!expectFailure) "!"} {
            hardening-check --nocfprotection --nobranchprotection \
              ${lib.optionalString ignoreBindNow "--nobindnow"} \
              ${lib.optionalString ignoreFortify "--nofortify"} \
              ${lib.optionalString ignorePie "--nopie"} \
              ${lib.optionalString ignoreRelRO "--norelro"} \
              ${lib.optionalString ignoreStackProtector "--nostackprotector"} \
              $(PATH=$HOST_PATH type -P test-bin) | tee $out
        ''
        + lib.optionalString (!ignoreStackClashProtection) ''
          # stack clash protection doesn't actually affect the exit code of
          # hardening-check (likely authors think false negatives too common)
          { grep -F '${stackClashStr}' $out || { echo "Didn't find '${stackClashStr}' in output" && false ;} ;}
        ''
        + ''
          } ; then
        ''
        + lib.optionalString expectFailure ''
          echo 'ERROR: Expected hardening-check to fail, but it passed!' >&2
        ''
        + ''
            exit 2
          fi
        ''
      );

  nameDrvAfterAttrName = builtins.mapAttrs (
    name: drv:
    drv.overrideAttrs (_: {
      name = "test-${name}";
    })
  );

  fortifyExecTest = fortifyExecTestFull true "012345 7" "0123456 7";

  # returning a specific exit code when aborting due to a fortify
  # check isn't mandated. so it's better to just ensure that a
  # nonzero exit code is returned when we go a single byte beyond
  # the buffer, with the example programs being designed to be
  # unlikely to genuinely segfault for such a small overflow.
  fortifyExecTestFull =
    expectProtection: saturatedArgs: oneTooFarArgs: testBin:
    runCommand "exec-test"
      {
        buildInputs = [
          testBin
        ];
        meta.broken = !(stdenv.buildPlatform.canExecute stdenv.hostPlatform);
      }
      ''
        (
          export PATH=$HOST_PATH
          echo "Saturated buffer:" # check program isn't completly broken
          test-bin ${saturatedArgs}
          echo "One byte too far:" # overflow byte being the null terminator?
          (
            ${if expectProtection then "!" else ""} test-bin ${oneTooFarArgs}
          ) || (
            echo 'Expected ${if expectProtection then "failure" else "success"}, but ${
              if expectProtection then "succeeded" else "failed"
            }!' && exit 1
          )
        )
        echo "Expected behaviour observed"
        touch $out
      '';

  brokenIf =
    cond: drv:
    if cond then
      drv.overrideAttrs (old: {
        meta = old.meta or { } // {
          broken = true;
        };
      })
    else
      drv;
  overridePlatforms =
    platforms: drv:
    drv.overrideAttrs (old: {
      meta = old.meta or { } // {
        inherit platforms;
      };
    });

  instructionPresenceTest =
    label: mnemonicPattern: testBin: expectFailure:
    runCommand "${label}-instr-test"
      {
        nativeBuildInputs = [
          bintools
        ];
        buildInputs = [
          testBin
        ];
      }
      ''
        touch $out
        if $OBJDUMP -d \
          --no-addresses \
          --no-show-raw-insn \
          "$(PATH=$HOST_PATH type -P test-bin)" \
          | grep -E '${mnemonicPattern}' > /dev/null ; then
          echo "Found ${label} instructions" >&2
          ${lib.optionalString expectFailure "exit 1"}
        else
          echo "Did not find ${label} instructions" >&2
          ${lib.optionalString (!expectFailure) "exit 1"}
        fi
      '';

  pacRetTest =
    testBin: expectFailure:
    overridePlatforms [ "aarch64-linux" ] (
      instructionPresenceTest "pacret" "\\bpaciasp\\b" testBin expectFailure
    );

  elfNoteTest =
    label: pattern: testBin: expectFailure:
    runCommand "${label}-elf-note-test"
      {
        nativeBuildInputs = [
          bintools
        ];
        buildInputs = [
          testBin
        ];
      }
      ''
        touch $out
        if $READELF -n "$(PATH=$HOST_PATH type -P test-bin)" \
          | grep -E '${pattern}' > /dev/null ; then
          echo "Found ${label} note" >&2
          ${lib.optionalString expectFailure "exit 1"}
        else
          echo "Did not find ${label} note" >&2
          ${lib.optionalString (!expectFailure) "exit 1"}
        fi
      '';

  shadowStackTest =
    testBin: expectFailure:
    brokenIf stdenv.hostPlatform.isMusl (
      overridePlatforms [ "x86_64-linux" ] (elfNoteTest "shadowstack" "\\bSHSTK\\b" testBin expectFailure)
    );

in
nameDrvAfterAttrName (
  {
    bindNowExplicitEnabled = brokenIf stdenv.hostPlatform.isStatic (
      checkTestBin
        (f2exampleWithStdEnv stdenv {
          hardeningEnable = [ "bindnow" ];
        })
        {
          ignoreBindNow = false;
        }
    );

    fortifyExplicitEnabled = (
      checkTestBin
        (f2exampleWithStdEnv stdenv {
          hardeningEnable = [ "fortify" ];
        })
        {
          ignoreFortify = false;
        }
    );

    fortify1ExplicitEnabledExecTest = fortifyExecTest (
      f1exampleWithStdEnv stdenv {
        hardeningEnable = [ "fortify" ];
      }
    );

    # musl implementation is effectively FORTIFY_SOURCE=1-only,
    fortifyExplicitEnabledExecTest = brokenIf stdenv.hostPlatform.isMusl (
      fortifyExecTest (
        f2exampleWithStdEnv stdenv {
          hardeningEnable = [ "fortify" ];
        }
      )
    );

    fortify3ExplicitEnabled = brokenIf (!stdenv.cc.isGNU || lib.versionOlder stdenv.cc.version "12") (
      checkTestBin
        (f3exampleWithStdEnv stdenv {
          hardeningEnable = [ "fortify3" ];
        })
        {
          ignoreFortify = false;
        }
    );

    # musl implementation is effectively FORTIFY_SOURCE=1-only
    fortify3ExplicitEnabledExecTest =
      brokenIf (stdenv.hostPlatform.isMusl || !stdenv.cc.isGNU || lib.versionOlder stdenv.cc.version "12")
        (
          fortifyExecTest (
            f3exampleWithStdEnv stdenv {
              hardeningEnable = [ "fortify3" ];
            }
          )
        );

    sfa1explicitEnabled =
      checkTestBin
        (flexArrF2ExampleWithStdEnv stdenv {
          hardeningEnable = [
            "fortify"
            "strictflexarrays1"
          ];
          env = {
            TEST_EXTRA_FLAGS = "-DBUFFER_DEF_SIZE=7";
          };
        })
        {
          ignoreFortify = false;
        };

    # musl implementation is effectively FORTIFY_SOURCE=1-only
    sfa1explicitEnabledExecTest = brokenIf stdenv.hostPlatform.isMusl (
      fortifyExecTestFull true "012345" "0123456" (
        flexArrF2ExampleWithStdEnv stdenv {
          hardeningEnable = [
            "fortify"
            "strictflexarrays1"
          ];
          env = {
            TEST_EXTRA_FLAGS = "-DBUFFER_DEF_SIZE=7";
          };
        }
      )
    );

    sfa1explicitEnabledDoesntProtectDefLen1 =
      checkTestBin
        (flexArrF2ExampleWithStdEnv stdenv {
          hardeningEnable = [
            "fortify"
            "strictflexarrays1"
          ];
          env = {
            TEST_EXTRA_FLAGS = "-DBUFFER_DEF_SIZE=1";
          };
        })
        {
          ignoreFortify = false;
          expectFailure = true;
        };

    # musl implementation is effectively FORTIFY_SOURCE=1-only
    sfa1explicitEnabledDoesntProtectDefLen1ExecTest = brokenIf stdenv.hostPlatform.isMusl (
      fortifyExecTestFull false "''" "0" (
        flexArrF2ExampleWithStdEnv stdenv {
          hardeningEnable = [
            "fortify"
            "strictflexarrays1"
          ];
          env = {
            TEST_EXTRA_FLAGS = "-DBUFFER_DEF_SIZE=1";
          };
        }
      )
    );

    sfa3explicitEnabledProtectsDefLen1 =
      checkTestBin
        (flexArrF2ExampleWithStdEnv stdenv {
          hardeningEnable = [
            "fortify"
            "strictflexarrays3"
          ];
          env = {
            TEST_EXTRA_FLAGS = "-DBUFFER_DEF_SIZE=1";
          };
        })
        {
          ignoreFortify = false;
        };

    # musl implementation is effectively FORTIFY_SOURCE=1-only
    sfa3explicitEnabledProtectsDefLen1ExecTest = brokenIf stdenv.hostPlatform.isMusl (
      fortifyExecTestFull true "''" "0" (
        flexArrF2ExampleWithStdEnv stdenv {
          hardeningEnable = [
            "fortify"
            "strictflexarrays3"
          ];
          env = {
            TEST_EXTRA_FLAGS = "-DBUFFER_DEF_SIZE=1";
          };
        }
      )
    );

    sfa3explicitEnabledDoesntProtectCorrectFlex =
      checkTestBin
        (flexArrF2ExampleWithStdEnv stdenv {
          hardeningEnable = [
            "fortify"
            "strictflexarrays3"
          ];
          env = {
            TEST_EXTRA_FLAGS = "-DBUFFER_DEF_SIZE=";
          };
        })
        {
          ignoreFortify = false;
          expectFailure = true;
        };

    # musl implementation is effectively FORTIFY_SOURCE=1-only
    sfa3explicitEnabledDoesntProtectCorrectFlexExecTest = brokenIf stdenv.hostPlatform.isMusl (
      fortifyExecTestFull false "" "0" (
        flexArrF2ExampleWithStdEnv stdenv {
          hardeningEnable = [
            "fortify"
            "strictflexarrays3"
          ];
          env = {
            TEST_EXTRA_FLAGS = "-DBUFFER_DEF_SIZE=";
          };
        }
      )
    );

    pieExplicitEnabled = brokenIf stdenv.hostPlatform.isStatic (
      checkTestBin
        (f2exampleWithStdEnv stdenv {
          hardeningEnable = [ "pie" ];
        })
        {
          ignorePie = false;
        }
    );

    pieExplicitEnabledStructuredAttrs = brokenIf stdenv.hostPlatform.isStatic (
      checkTestBin
        (f2exampleWithStdEnv stdenv {
          hardeningEnable = [ "pie" ];
          __structuredAttrs = true;
        })
        {
          ignorePie = false;
        }
    );

    relROExplicitEnabled =
      checkTestBin
        (f2exampleWithStdEnv stdenv {
          hardeningEnable = [ "relro" ];
        })
        {
          ignoreRelRO = false;
        };

    stackProtectorExplicitEnabled = brokenIf stdenv.hostPlatform.isStatic (
      checkTestBin
        (f2exampleWithStdEnv stdenv {
          hardeningEnable = [ "stackprotector" ];
        })
        {
          ignoreStackProtector = false;
        }
    );

    # protection patterns generated by clang not detectable?
    stackClashProtectionExplicitEnabled = brokenIf stdenv.cc.isClang (
      checkTestBin
        (helloWithStdEnv stdenv {
          hardeningEnable = [ "stackclashprotection" ];
        })
        {
          ignoreStackClashProtection = false;
        }
    );

    pacRetExplicitEnabled = pacRetTest (helloWithStdEnv stdenv {
      hardeningEnable = [ "pacret" ];
    }) false;

    shadowStackExplicitEnabled = shadowStackTest (f1exampleWithStdEnv stdenv {
      hardeningEnable = [ "shadowstack" ];
    }) false;

    glibcxxassertionsExplicitEnabled = checkGlibcxxassertionsWithStdEnv true stdenv {
      hardeningEnable = [ "glibcxxassertions" ];
    };

    bindNowExplicitDisabled =
      checkTestBin
        (f2exampleWithStdEnv stdenv {
          hardeningDisable = [ "bindnow" ];
        })
        {
          ignoreBindNow = false;
          expectFailure = true;
        };

    fortifyExplicitDisabled =
      checkTestBin
        (f2exampleWithStdEnv stdenv {
          hardeningDisable = [ "fortify" ];
        })
        {
          ignoreFortify = false;
          expectFailure = true;
        };

    fortify3ExplicitDisabled =
      checkTestBin
        (f3exampleWithStdEnv stdenv {
          hardeningDisable = [ "fortify3" ];
        })
        {
          ignoreFortify = false;
          expectFailure = true;
        };

    fortifyExplicitDisabledDisablesFortify3 =
      checkTestBin
        (f3exampleWithStdEnv stdenv {
          hardeningEnable = [ "fortify3" ];
          hardeningDisable = [ "fortify" ];
        })
        {
          ignoreFortify = false;
          expectFailure = true;
        };

    fortify3ExplicitDisabledDoesntDisableFortify =
      checkTestBin
        (f2exampleWithStdEnv stdenv {
          hardeningEnable = [ "fortify" ];
          hardeningDisable = [ "fortify3" ];
        })
        {
          ignoreFortify = false;
        };

    # musl implementation is effectively FORTIFY_SOURCE=1-only
    sfa1explicitDisabled = brokenIf stdenv.hostPlatform.isMusl (
      checkTestBin
        (flexArrF2ExampleWithStdEnv stdenv {
          hardeningEnable = [ "fortify" ];
          hardeningDisable = [ "strictflexarrays1" ];
          env = {
            TEST_EXTRA_FLAGS = "-DBUFFER_DEF_SIZE=7";
          };
        })
        {
          ignoreFortify = false;
          expectFailure = true;
        }
    );

    sfa1explicitDisabledExecTest = fortifyExecTestFull false "012345" "0123456" (
      flexArrF2ExampleWithStdEnv stdenv {
        hardeningEnable = [ "fortify" ];
        hardeningDisable = [ "strictflexarrays1" ];
        env = {
          TEST_EXTRA_FLAGS = "-DBUFFER_DEF_SIZE=7";
        };
      }
    );

    # musl implementation is effectively FORTIFY_SOURCE=1-only
    sfa1explicitDisabledDisablesSfa3 = brokenIf stdenv.hostPlatform.isMusl (
      checkTestBin
        (flexArrF2ExampleWithStdEnv stdenv {
          hardeningEnable = [
            "fortify"
            "strictflexarrays3"
          ];
          hardeningDisable = [ "strictflexarrays1" ];
          env = {
            TEST_EXTRA_FLAGS = "-DBUFFER_DEF_SIZE=1";
          };
        })
        {
          ignoreFortify = false;
          expectFailure = true;
        }
    );

    # musl implementation is effectively FORTIFY_SOURCE=1-only
    sfa1explicitDisabledDisablesSfa3ExecTest = brokenIf stdenv.hostPlatform.isMusl (
      fortifyExecTestFull false "''" "0" (
        flexArrF2ExampleWithStdEnv stdenv {
          hardeningEnable = [
            "fortify"
            "strictflexarrays3"
          ];
          hardeningDisable = [ "strictflexarrays1" ];
          env = {
            TEST_EXTRA_FLAGS = "-DBUFFER_DEF_SIZE=1";
          };
        }
      )
    );

    sfa3explicitDisabledDoesntDisableSfa1 =
      checkTestBin
        (flexArrF2ExampleWithStdEnv stdenv {
          hardeningEnable = [
            "fortify"
            "strictflexarrays1"
          ];
          hardeningDisable = [ "strictflexarrays3" ];
          env = {
            TEST_EXTRA_FLAGS = "-DBUFFER_DEF_SIZE=7";
          };
        })
        {
          ignoreFortify = false;
        };

    # musl implementation is effectively FORTIFY_SOURCE=1-only
    sfa3explicitDisabledDoesntDisableSfa1ExecTest = brokenIf stdenv.hostPlatform.isMusl (
      fortifyExecTestFull true "012345" "0123456" (
        flexArrF2ExampleWithStdEnv stdenv {
          hardeningEnable = [
            "fortify"
            "strictflexarrays1"
          ];
          hardeningDisable = [ "strictflexarrays3" ];
          env = {
            TEST_EXTRA_FLAGS = "-DBUFFER_DEF_SIZE=7";
          };
        }
      )
    );

    pieExplicitDisabled = brokenIf (stdenv.hostPlatform.isMusl && stdenv.cc.isClang) (
      checkTestBin
        (f2exampleWithStdEnv stdenv {
          hardeningDisable = [ "pie" ];
        })
        {
          ignorePie = false;
          expectFailure = true;
        }
    );

    # can't force-disable ("partial"?) relro
    relROExplicitDisabled = brokenIf true (
      checkTestBin
        (f2exampleWithStdEnv stdenv {
          hardeningDisable = [ "pie" ];
        })
        {
          ignoreRelRO = false;
          expectFailure = true;
        }
    );

    stackProtectorExplicitDisabled =
      checkTestBin
        (f2exampleWithStdEnv stdenv {
          hardeningDisable = [ "stackprotector" ];
        })
        {
          ignoreStackProtector = false;
          expectFailure = true;
        };

    stackClashProtectionExplicitDisabled =
      checkTestBin
        (helloWithStdEnv stdenv {
          hardeningDisable = [ "stackclashprotection" ];
        })
        {
          ignoreStackClashProtection = false;
          expectFailure = true;
        };

    pacRetExplicitDisabled = pacRetTest (helloWithStdEnv stdenv {
      hardeningDisable = [ "pacret" ];
    }) true;

    shadowStackExplicitDisabled = shadowStackTest (f1exampleWithStdEnv stdenv {
      hardeningDisable = [ "shadowstack" ];
    }) true;

    glibcxxassertionsExplicitDisabled = checkGlibcxxassertionsWithStdEnv false stdenv {
      hardeningDisable = [ "glibcxxassertions" ];
    };

    # most flags can't be "unsupported" by compiler alone and
    # binutils doesn't have an accessible hardeningUnsupportedFlags
    # mechanism, so can only test a couple of flags through altered
    # stdenv trickery

    fortifyStdenvUnsupp =
      checkTestBin
        (f2exampleWithStdEnv
          (stdenvUnsupport [
            "fortify"
            "fortify3"
          ])
          {
            hardeningEnable = [ "fortify" ];
          }
        )
        {
          ignoreFortify = false;
          expectFailure = true;
        };

    fortify3StdenvUnsupp =
      checkTestBin
        (f3exampleWithStdEnv (stdenvUnsupport [ "fortify3" ]) {
          hardeningEnable = [ "fortify3" ];
        })
        {
          ignoreFortify = false;
          expectFailure = true;
        };

    fortifyStdenvUnsuppUnsupportsFortify3 =
      checkTestBin
        (f3exampleWithStdEnv (stdenvUnsupport [ "fortify" ]) {
          hardeningEnable = [ "fortify3" ];
        })
        {
          ignoreFortify = false;
          expectFailure = true;
        };

    fortify3StdenvUnsuppDoesntUnsuppFortify1 =
      checkTestBin
        (f1exampleWithStdEnv (stdenvUnsupport [ "fortify3" ]) {
          hardeningEnable = [ "fortify" ];
        })
        {
          ignoreFortify = false;
        };

    fortify3StdenvUnsuppDoesntUnsuppFortify1ExecTest = fortifyExecTest (
      f1exampleWithStdEnv (stdenvUnsupport [ "fortify3" ]) {
        hardeningEnable = [ "fortify" ];
      }
    );

    sfa1StdenvUnsupp =
      checkTestBin
        (flexArrF2ExampleWithStdEnv
          (stdenvUnsupport [
            "strictflexarrays1"
            "strictflexarrays3"
          ])
          {
            hardeningEnable = [
              "fortify"
              "strictflexarrays1"
            ];
            env = {
              TEST_EXTRA_FLAGS = "-DBUFFER_DEF_SIZE=7";
            };
          }
        )
        {
          ignoreFortify = false;
          expectFailure = true;
        };

    sfa3StdenvUnsupp =
      checkTestBin
        (flexArrF2ExampleWithStdEnv (stdenvUnsupport [ "strictflexarrays3" ]) {
          hardeningEnable = [
            "fortify"
            "strictflexarrays3"
          ];
          env = {
            TEST_EXTRA_FLAGS = "-DBUFFER_DEF_SIZE=1";
          };
        })
        {
          ignoreFortify = false;
          expectFailure = true;
        };

    sfa1StdenvUnsuppUnsupportsSfa3 =
      checkTestBin
        (flexArrF2ExampleWithStdEnv (stdenvUnsupport [ "strictflexarrays1" ]) {
          hardeningEnable = [
            "fortify"
            "strictflexarrays3"
          ];
          env = {
            TEST_EXTRA_FLAGS = "-DBUFFER_DEF_SIZE=1";
          };
        })
        {
          ignoreFortify = false;
          expectFailure = true;
        };

    sfa3StdenvUnsuppDoesntUnsuppSfa1 =
      checkTestBin
        (flexArrF2ExampleWithStdEnv (stdenvUnsupport [ "strictflexarrays3" ]) {
          hardeningEnable = [
            "fortify"
            "strictflexarrays1"
          ];
          env = {
            TEST_EXTRA_FLAGS = "-DBUFFER_DEF_SIZE=7";
          };
        })
        {
          ignoreFortify = false;
        };

    # musl implementation is effectively FORTIFY_SOURCE=1-only
    sfa3StdenvUnsuppDoesntUnsuppSfa1ExecTest = brokenIf stdenv.hostPlatform.isMusl (
      fortifyExecTestFull true "012345" "0123456" (
        flexArrF2ExampleWithStdEnv (stdenvUnsupport [ "strictflexarrays3" ]) {
          hardeningEnable = [
            "fortify"
            "strictflexarrays1"
          ];
          env = {
            TEST_EXTRA_FLAGS = "-DBUFFER_DEF_SIZE=7";
          };
        }
      )
    );

    stackProtectorStdenvUnsupp =
      checkTestBin
        (f2exampleWithStdEnv (stdenvUnsupport [ "stackprotector" ]) {
          hardeningEnable = [ "stackprotector" ];
        })
        {
          ignoreStackProtector = false;
          expectFailure = true;
        };

    stackClashProtectionStdenvUnsupp =
      checkTestBin
        (helloWithStdEnv (stdenvUnsupport [ "stackclashprotection" ]) {
          hardeningEnable = [ "stackclashprotection" ];
        })
        {
          ignoreStackClashProtection = false;
          expectFailure = true;
        };

    # NIX_HARDENING_ENABLE set in the shell overrides hardeningDisable
    # and hardeningEnable

    stackProtectorReenabledEnv =
      checkTestBin
        (f2exampleWithStdEnv stdenv {
          hardeningDisable = [ "stackprotector" ];
          postConfigure = ''
            export NIX_HARDENING_ENABLE="stackprotector"
          '';
        })
        {
          ignoreStackProtector = false;
        };

    stackProtectorReenabledFromAllEnv =
      checkTestBin
        (f2exampleWithStdEnv stdenv {
          hardeningDisable = [ "all" ];
          postConfigure = ''
            export NIX_HARDENING_ENABLE="stackprotector"
          '';
        })
        {
          ignoreStackProtector = false;
        };

    stackProtectorRedisabledEnv =
      checkTestBin
        (f2exampleWithStdEnv stdenv {
          hardeningEnable = [ "stackprotector" ];
          postConfigure = ''
            export NIX_HARDENING_ENABLE=""
          '';
        })
        {
          ignoreStackProtector = false;
          expectFailure = true;
        };

    glibcxxassertionsStdenvUnsupp =
      checkGlibcxxassertionsWithStdEnv false (stdenvUnsupport [ "glibcxxassertions" ])
        {
          hardeningEnable = [ "glibcxxassertions" ];
        };

    fortify3EnabledEnvEnablesFortify1 =
      checkTestBin
        (f1exampleWithStdEnv stdenv {
          hardeningDisable = [
            "fortify"
            "fortify3"
          ];
          postConfigure = ''
            export NIX_HARDENING_ENABLE="fortify3"
          '';
        })
        {
          ignoreFortify = false;
        };

    fortify3EnabledEnvEnablesFortify1ExecTest = fortifyExecTest (
      f1exampleWithStdEnv stdenv {
        hardeningDisable = [
          "fortify"
          "fortify3"
        ];
        postConfigure = ''
          export NIX_HARDENING_ENABLE="fortify3"
        '';
      }
    );

    fortifyEnabledEnvDoesntEnableFortify3 =
      checkTestBin
        (f3exampleWithStdEnv stdenv {
          hardeningDisable = [
            "fortify"
            "fortify3"
          ];
          postConfigure = ''
            export NIX_HARDENING_ENABLE="fortify"
          '';
        })
        {
          ignoreFortify = false;
          expectFailure = true;
        };

    sfa3EnabledEnvEnablesSfa1 =
      checkTestBin
        (flexArrF2ExampleWithStdEnv stdenv {
          hardeningDisable = [
            "strictflexarrays1"
            "strictflexarrays3"
          ];
          postConfigure = ''
            export NIX_HARDENING_ENABLE="fortify strictflexarrays3"
          '';
          env = {
            TEST_EXTRA_FLAGS = "-DBUFFER_DEF_SIZE=7";
          };
        })
        {
          ignoreFortify = false;
        };

    sfa3EnabledEnvEnablesSfa1ExecTest = fortifyExecTestFull true "012345" "0123456" (
      f1exampleWithStdEnv stdenv {
        hardeningDisable = [
          "strictflexarrays1"
          "strictflexarrays3"
        ];
        postConfigure = ''
          export NIX_HARDENING_ENABLE="fortify strictflexarrays3"
        '';
        env = {
          TEST_EXTRA_FLAGS = "-DBUFFER_DEF_SIZE=7";
        };
      }
    );

    sfa1EnabledEnvDoesntEnableSfa3 =
      checkTestBin
        (flexArrF2ExampleWithStdEnv stdenv {
          hardeningDisable = [
            "strictflexarrays1"
            "strictflexarrays3"
          ];
          postConfigure = ''
            export NIX_HARDENING_ENABLE="fortify strictflexarrays1"
          '';
          env = {
            TEST_EXTRA_FLAGS = "-DBUFFER_DEF_SIZE=1";
          };
        })
        {
          ignoreFortify = false;
          expectFailure = true;
        };

    # NIX_HARDENING_ENABLE can't enable an unsupported feature
    stackProtectorUnsupportedEnabledEnv =
      checkTestBin
        (f2exampleWithStdEnv (stdenvUnsupport [ "stackprotector" ]) {
          postConfigure = ''
            export NIX_HARDENING_ENABLE="stackprotector"
          '';
        })
        {
          ignoreStackProtector = false;
          expectFailure = true;
        };

    # current implementation prevents the command-line from disabling
    # fortify if cc-wrapper is enabling it.

    fortify1ExplicitEnabledCmdlineDisabled =
      checkTestBin
        (f1exampleWithStdEnv stdenv {
          hardeningEnable = [ "fortify" ];
          postConfigure = ''
            export TEST_EXTRA_FLAGS='-D_FORTIFY_SOURCE=0'
          '';
        })
        {
          ignoreFortify = false;
          expectFailure = false;
        };

    # current implementation doesn't force-disable fortify if
    # command-line enables it even if we use hardeningDisable.

    fortify1ExplicitDisabledCmdlineEnabled =
      checkTestBin
        (f1exampleWithStdEnv stdenv {
          hardeningDisable = [ "fortify" ];
          postConfigure = ''
            export TEST_EXTRA_FLAGS='-D_FORTIFY_SOURCE=1'
          '';
        })
        {
          ignoreFortify = false;
        };

    fortify1ExplicitDisabledCmdlineEnabledExecTest = fortifyExecTest (
      f1exampleWithStdEnv stdenv {
        hardeningDisable = [ "fortify" ];
        postConfigure = ''
          export TEST_EXTRA_FLAGS='-D_FORTIFY_SOURCE=1'
        '';
      }
    );

    fortify1ExplicitEnabledCmdlineDisabledNoWarn = f1exampleWithStdEnv stdenv {
      hardeningEnable = [ "fortify" ];
      postConfigure = ''
        export TEST_EXTRA_FLAGS='-D_FORTIFY_SOURCE=0 -Werror'
      '';
    };

  }
  // (
    let
      tb = f2exampleWithStdEnv stdenv {
        hardeningDisable = [ "all" ];
        hardeningEnable = [
          "fortify"
          "pie"
        ];
      };
    in
    {

      allExplicitDisabledBindNow = checkTestBin tb {
        ignoreBindNow = false;
        expectFailure = true;
      };

      allExplicitDisabledFortify = checkTestBin tb {
        ignoreFortify = false;
        expectFailure = true;
      };

      allExplicitDisabledPie = brokenIf (stdenv.hostPlatform.isMusl && stdenv.cc.isClang) (
        checkTestBin tb {
          ignorePie = false;
          expectFailure = true;
        }
      );

      # can't force-disable ("partial"?) relro
      allExplicitDisabledRelRO = brokenIf true (
        checkTestBin tb {
          ignoreRelRO = false;
          expectFailure = true;
        }
      );

      allExplicitDisabledStackProtector = checkTestBin tb {
        ignoreStackProtector = false;
        expectFailure = true;
      };

      allExplicitDisabledStackClashProtection = checkTestBin tb {
        ignoreStackClashProtection = false;
        expectFailure = true;
      };

      allExplicitDisabledPacRet = pacRetTest (helloWithStdEnv stdenv {
        hardeningDisable = [ "all" ];
      }) true;

      allExplicitDisabledShadowStack = shadowStackTest (f1exampleWithStdEnv stdenv {
        hardeningDisable = [ "all" ];
      }) true;

      glibcxxassertionsExplicitDisabled = checkGlibcxxassertionsWithStdEnv false stdenv {
        hardeningDisable = [ "all" ];
      };
    }
  )
)
