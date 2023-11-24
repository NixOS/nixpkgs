{ lib
, stdenv
, runCommand
, runCommandWith
, runCommandCC
, debian-devscripts
}:

let
  # writeCBin from trivial-builders won't let us choose
  # our own stdenv
  writeCBinWithStdenv = codePath: stdenv': env: runCommandWith {
    name = "test-bin";
    stdenv = stdenv';
    derivationArgs = {
      inherit codePath;
      preferLocalBuild = true;
      allowSubstitutes = false;
    } // env;
  } ''
    [ -n "$preBuild" ] && eval "$preBuild"
    n=$out/bin/test-bin
    mkdir -p "$(dirname "$n")"
    cp "$codePath" code.c
    NIX_DEBUG=1 $CC -x c code.c -O1 $TEST_EXTRA_FLAGS -o "$n"
  '';

  f1exampleWithStdEnv = writeCBinWithStdenv ./fortify1-example.c;
  f2exampleWithStdEnv = writeCBinWithStdenv ./fortify2-example.c;
  f3exampleWithStdEnv = writeCBinWithStdenv ./fortify3-example.c;

  stdenvUnsupport = additionalUnsupported: stdenv.override {
    cc = stdenv.cc.override {
      cc = (lib.extendDerivation true {
        hardeningUnsupportedFlags = (stdenv.cc.cc.hardeningUnsupportedFlags or []) ++ additionalUnsupported;
      } stdenv.cc.cc);
    };
    allowedRequisites = null;
  };

  checkTestBin = testBin: {
    # can only test flags that are detectable by hardening-check
    ignoreBindNow ? true,
    ignoreFortify ? true,
    ignorePie ? true,
    ignoreRelRO ? true,
    ignoreStackProtector ? true,
    expectFailure ? false,
  }: let
    expectFailureClause = lib.optionalString expectFailure
      " && echo 'ERROR: Expected hardening-check to fail, but it passed!' >&2 && exit 1";
  in runCommandCC "check-test-bin" {
    nativeBuildInputs = [ debian-devscripts ];
    buildInputs = [ testBin ];
    meta.platforms = lib.platforms.linux;  # ELF-reliant
  } ''
    hardening-check --nocfprotection \
      ${lib.optionalString ignoreBindNow "--nobindnow"} \
      ${lib.optionalString ignoreFortify "--nofortify"} \
      ${lib.optionalString ignorePie "--nopie"} \
      ${lib.optionalString ignoreRelRO "--norelro"} \
      ${lib.optionalString ignoreStackProtector "--nostackprotector"} \
      $(PATH=$HOST_PATH type -P test-bin) ${expectFailureClause}
    touch $out
  '';

  nameDrvAfterAttrName = builtins.mapAttrs (name: drv:
    drv.overrideAttrs (_: { name = "test-${name}"; })
  );

  # returning a specific exit code when aborting due to a fortify
  # check isn't mandated. so it's better to just ensure that a
  # nonzero exit code is returned when we go a single byte beyond
  # the buffer, with the example programs being designed to be
  # unlikely to genuinely segfault for such a small overflow.
  fortifyExecTest = testBin: runCommand "exec-test" {
    buildInputs = [
      testBin
    ];
    meta.broken = !(stdenv.buildPlatform.canExecute stdenv.hostPlatform);
  } ''
    (
      export PATH=$HOST_PATH
      echo "Saturated buffer:" # check program isn't completly broken
      test-bin 012345 7
      echo "One byte too far:" # eighth byte being the null terminator
      (! test-bin 0123456 7) || (echo 'Expected failure, but succeeded!' && exit 1)
    )
    echo "Expected behaviour observed"
    touch $out
  '';

  brokenIf = cond: drv: if cond then drv.overrideAttrs (old: { meta = old.meta or {} // { broken = true; }; }) else drv;

in nameDrvAfterAttrName ({
  bindNowExplicitEnabled = brokenIf stdenv.hostPlatform.isStatic (checkTestBin (f2exampleWithStdEnv stdenv {
    hardeningEnable = [ "bindnow" ];
  }) {
    ignoreBindNow = false;
  });

  # musl implementation undetectable by this means even if present
  fortifyExplicitEnabled = brokenIf stdenv.hostPlatform.isMusl (checkTestBin (f2exampleWithStdEnv stdenv {
    hardeningEnable = [ "fortify" ];
  }) {
    ignoreFortify = false;
  });

  fortify1ExplicitEnabledExecTest = fortifyExecTest (f1exampleWithStdEnv stdenv {
    hardeningEnable = [ "fortify" ];
  });

  # musl implementation is effectively FORTIFY_SOURCE=1-only,
  # clang-on-glibc also only appears to support FORTIFY_SOURCE=1 (!)
  fortifyExplicitEnabledExecTest = brokenIf (
    stdenv.hostPlatform.isMusl || (stdenv.cc.isClang && stdenv.hostPlatform.libc == "glibc")
  ) (fortifyExecTest (f2exampleWithStdEnv stdenv {
    hardeningEnable = [ "fortify" ];
  }));

  fortify3ExplicitEnabled = brokenIf (
    stdenv.hostPlatform.isMusl || !stdenv.cc.isGNU || lib.versionOlder stdenv.cc.version "12"
  ) (checkTestBin (f3exampleWithStdEnv stdenv {
    hardeningEnable = [ "fortify3" ];
  }) {
    ignoreFortify = false;
  });

  # musl implementation is effectively FORTIFY_SOURCE=1-only
  fortify3ExplicitEnabledExecTest = brokenIf (
    stdenv.hostPlatform.isMusl || !stdenv.cc.isGNU || lib.versionOlder stdenv.cc.version "12"
  ) (fortifyExecTest (f3exampleWithStdEnv stdenv {
    hardeningEnable = [ "fortify3" ];
  }));

  pieExplicitEnabled = brokenIf stdenv.hostPlatform.isStatic (checkTestBin (f2exampleWithStdEnv stdenv {
    hardeningEnable = [ "pie" ];
  }) {
    ignorePie = false;
  });

  relROExplicitEnabled = checkTestBin (f2exampleWithStdEnv stdenv {
    hardeningEnable = [ "relro" ];
  }) {
    ignoreRelRO = false;
  };

  stackProtectorExplicitEnabled = brokenIf stdenv.hostPlatform.isStatic (checkTestBin (f2exampleWithStdEnv stdenv {
    hardeningEnable = [ "stackprotector" ];
  }) {
    ignoreStackProtector = false;
  });

  bindNowExplicitDisabled = checkTestBin (f2exampleWithStdEnv stdenv {
    hardeningDisable = [ "bindnow" ];
  }) {
    ignoreBindNow = false;
    expectFailure = true;
  };

  fortifyExplicitDisabled = checkTestBin (f2exampleWithStdEnv stdenv {
    hardeningDisable = [ "fortify" ];
  }) {
    ignoreFortify = false;
    expectFailure = true;
  };

  fortify3ExplicitDisabled = checkTestBin (f3exampleWithStdEnv stdenv {
    hardeningDisable = [ "fortify3" ];
  }) {
    ignoreFortify = false;
    expectFailure = true;
  };

  fortifyExplicitDisabledDisablesFortify3 = checkTestBin (f3exampleWithStdEnv stdenv {
    hardeningEnable = [ "fortify3" ];
    hardeningDisable = [ "fortify" ];
  }) {
    ignoreFortify = false;
    expectFailure = true;
  };

  fortify3ExplicitDisabledDoesntDisableFortify = checkTestBin (f2exampleWithStdEnv stdenv {
    hardeningEnable = [ "fortify" ];
    hardeningDisable = [ "fortify3" ];
  }) {
    ignoreFortify = false;
  };

  pieExplicitDisabled = brokenIf (
    stdenv.hostPlatform.isMusl && stdenv.cc.isClang
  ) (checkTestBin (f2exampleWithStdEnv stdenv {
    hardeningDisable = [ "pie" ];
  }) {
    ignorePie = false;
    expectFailure = true;
  });

  # can't force-disable ("partial"?) relro
  relROExplicitDisabled = brokenIf true (checkTestBin (f2exampleWithStdEnv stdenv {
    hardeningDisable = [ "pie" ];
  }) {
    ignoreRelRO = false;
    expectFailure = true;
  });

  stackProtectorExplicitDisabled = checkTestBin (f2exampleWithStdEnv stdenv {
    hardeningDisable = [ "stackprotector" ];
  }) {
    ignoreStackProtector = false;
    expectFailure = true;
  };

  # most flags can't be "unsupported" by compiler alone and
  # binutils doesn't have an accessible hardeningUnsupportedFlags
  # mechanism, so can only test a couple of flags through altered
  # stdenv trickery

  fortifyStdenvUnsupp = checkTestBin (f2exampleWithStdEnv (stdenvUnsupport ["fortify"]) {
    hardeningEnable = [ "fortify" ];
  }) {
    ignoreFortify = false;
    expectFailure = true;
  };

  fortify3StdenvUnsupp = checkTestBin (f3exampleWithStdEnv (stdenvUnsupport ["fortify3"]) {
    hardeningEnable = [ "fortify3" ];
  }) {
    ignoreFortify = false;
    expectFailure = true;
  };

  fortifyStdenvUnsuppUnsupportsFortify3 = checkTestBin (f3exampleWithStdEnv (stdenvUnsupport ["fortify"]) {
    hardeningEnable = [ "fortify3" ];
  }) {
    ignoreFortify = false;
    expectFailure = true;
  };

  fortify3StdenvUnsuppDoesntUnsuppFortify = brokenIf stdenv.hostPlatform.isMusl (checkTestBin (f2exampleWithStdEnv (stdenvUnsupport ["fortify3"]) {
    hardeningEnable = [ "fortify" ];
  }) {
    ignoreFortify = false;
  });

  fortify3StdenvUnsuppDoesntUnsuppFortifyExecTest = fortifyExecTest (f2exampleWithStdEnv (stdenvUnsupport ["fortify3"]) {
    hardeningEnable = [ "fortify" ];
  });

  stackProtectorStdenvUnsupp = checkTestBin (f2exampleWithStdEnv (stdenvUnsupport ["stackprotector"]) {
    hardeningEnable = [ "stackprotector" ];
  }) {
    ignoreStackProtector = false;
    expectFailure = true;
  };

  # NIX_HARDENING_ENABLE set in the shell overrides hardeningDisable
  # and hardeningEnable

  stackProtectorReenabledEnv = checkTestBin (f2exampleWithStdEnv stdenv {
    hardeningDisable = [ "stackprotector" ];
    preBuild = ''
      export NIX_HARDENING_ENABLE="stackprotector"
    '';
  }) {
    ignoreStackProtector = false;
  };

  stackProtectorReenabledFromAllEnv = checkTestBin (f2exampleWithStdEnv stdenv {
    hardeningDisable = [ "all" ];
    preBuild = ''
      export NIX_HARDENING_ENABLE="stackprotector"
    '';
  }) {
    ignoreStackProtector = false;
  };

  stackProtectorRedisabledEnv = checkTestBin (f2exampleWithStdEnv stdenv {
    hardeningEnable = [ "stackprotector" ];
    preBuild = ''
      export NIX_HARDENING_ENABLE=""
    '';
  }) {
    ignoreStackProtector = false;
    expectFailure = true;
  };

  fortify3EnabledEnvEnablesFortify = brokenIf stdenv.hostPlatform.isMusl (checkTestBin (f2exampleWithStdEnv stdenv {
    hardeningDisable = [ "fortify" "fortify3" ];
    preBuild = ''
      export NIX_HARDENING_ENABLE="fortify3"
    '';
  }) {
    ignoreFortify = false;
  });

  fortify3EnabledEnvEnablesFortifyExecTest = fortifyExecTest (f2exampleWithStdEnv stdenv {
    hardeningDisable = [ "fortify" "fortify3" ];
    preBuild = ''
      export NIX_HARDENING_ENABLE="fortify3"
    '';
  });

  fortifyEnabledEnvDoesntEnableFortify3 = checkTestBin (f3exampleWithStdEnv stdenv {
    hardeningDisable = [ "fortify" "fortify3" ];
    preBuild = ''
      export NIX_HARDENING_ENABLE="fortify"
    '';
  }) {
    ignoreFortify = false;
    expectFailure = true;
  };

  # NIX_HARDENING_ENABLE can't enable an unsupported feature

  stackProtectorUnsupportedEnabledEnv = checkTestBin (f2exampleWithStdEnv (stdenvUnsupport ["stackprotector"]) {
    preBuild = ''
      export NIX_HARDENING_ENABLE="stackprotector"
    '';
  }) {
    ignoreStackProtector = false;
    expectFailure = true;
  };

  # undetectable by this means on static even if present
  fortify1ExplicitEnabledCmdlineDisabled = brokenIf stdenv.hostPlatform.isStatic (checkTestBin (f1exampleWithStdEnv stdenv {
    hardeningEnable = [ "fortify" ];
    preBuild = ''
      export TEST_EXTRA_FLAGS='-D_FORTIFY_SOURCE=0'
    '';
  }) {
    ignoreFortify = false;
    expectFailure = true;
  });

  # musl implementation undetectable by this means even if present
  fortify1ExplicitDisabledCmdlineEnabled = brokenIf (
    stdenv.hostPlatform.isMusl || stdenv.hostPlatform.isStatic
  ) (checkTestBin (f1exampleWithStdEnv stdenv {
    hardeningDisable = [ "fortify" ];
    preBuild = ''
      export TEST_EXTRA_FLAGS='-D_FORTIFY_SOURCE=1'
    '';
  }) {
    ignoreFortify = false;
  });

  fortify1ExplicitDisabledCmdlineEnabledExecTest = fortifyExecTest (f1exampleWithStdEnv stdenv {
    hardeningDisable = [ "fortify" ];
    preBuild = ''
      export TEST_EXTRA_FLAGS='-D_FORTIFY_SOURCE=1'
    '';
  });

  fortify1ExplicitEnabledCmdlineDisabledNoWarn = f1exampleWithStdEnv stdenv {
    hardeningEnable = [ "fortify" ];
    preBuild = ''
      export TEST_EXTRA_FLAGS='-D_FORTIFY_SOURCE=0 -Werror'
    '';
  };

} // (let
  tb = f2exampleWithStdEnv stdenv {
    hardeningDisable = [ "all" ];
    hardeningEnable = [ "fortify" "pie" ];
  };
in {

  allExplicitDisabledBindNow = checkTestBin tb {
    ignoreBindNow = false;
    expectFailure = true;
  };

  allExplicitDisabledFortify = checkTestBin tb {
    ignoreFortify = false;
    expectFailure = true;
  };

  allExplicitDisabledPie = brokenIf (
    stdenv.hostPlatform.isMusl && stdenv.cc.isClang
  ) (checkTestBin tb {
    ignorePie = false;
    expectFailure = true;
  });

  # can't force-disable ("partial"?) relro
  allExplicitDisabledRelRO = brokenIf true (checkTestBin tb {
    ignoreRelRO = false;
    expectFailure = true;
  });

  allExplicitDisabledStackProtector = checkTestBin tb {
    ignoreStackProtector = false;
    expectFailure = true;
  };
}))
