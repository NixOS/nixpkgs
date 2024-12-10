{ pkgs, lib }:

let

  testedSystems = lib.filterAttrs (
    name: value:
    let
      platform = lib.systems.elaborate value;
    in
    platform.isLinux || platform.isWindows
  ) lib.systems.examples;

  getExecutable =
    pkgs: pkgFun: exec:
    "${pkgFun pkgs}${exec}${pkgs.stdenv.hostPlatform.extensions.executable}";

  compareTest =
    {
      emulator,
      pkgFun,
      hostPkgs,
      crossPkgs,
      exec,
      args ? [ ],
    }:
    let
      pkgName = (pkgFun hostPkgs).name;
      args' = lib.concatStringsSep " " args;
    in
    crossPkgs.runCommand "test-${pkgName}-${crossPkgs.stdenv.hostPlatform.config}"
      {
        nativeBuildInputs = [ pkgs.dos2unix ];
      }
      ''
        # Just in case we are using wine, get rid of that annoying extra
        # stuff.
        export WINEDEBUG=-all

        HOME=$(pwd)
        mkdir -p $out

        # We need to remove whitespace, unfortunately
        # Windows programs use \r but Unix programs use \n

        echo Running native-built program natively

        # find expected value natively
        ${getExecutable hostPkgs pkgFun exec} ${args'} \
          | dos2unix > $out/expected

        echo Running cross-built program in emulator

        # run emulator to get actual value
        ${emulator} ${getExecutable crossPkgs pkgFun exec} ${args'} \
          | dos2unix > $out/actual

        echo Comparing results...

        if [ "$(cat $out/actual)" != "$(cat $out/expected)" ]; then
          echo "${pkgName} did not output expected value:"
          cat $out/expected
          echo "instead it output:"
          cat $out/actual
          exit 1
        else
          echo "${pkgName} test passed"
          echo "both produced output:"
          cat $out/actual
        fi
      '';

  mapMultiPlatformTest =
    crossSystemFun: test:
    lib.mapAttrs (
      name: system:
      test rec {
        crossPkgs = import pkgs.path {
          localSystem = { inherit (pkgs.stdenv.hostPlatform) config; };
          crossSystem = crossSystemFun system;
        };

        emulator = crossPkgs.stdenv.hostPlatform.emulator pkgs;

        # Apply some transformation on windows to get dlls in the right
        # place. Unfortunately mingw doesn’t seem to be able to do linking
        # properly.
        platformFun =
          pkg:
          if crossPkgs.stdenv.hostPlatform.isWindows then
            pkgs.buildEnv {
              name = "${pkg.name}-winlinks";
              paths = [ pkg ] ++ pkg.buildInputs;
            }
          else
            pkg;
      }
    ) testedSystems;

  tests = {

    file =
      {
        platformFun,
        crossPkgs,
        emulator,
      }:
      compareTest {
        inherit emulator crossPkgs;
        hostPkgs = pkgs;
        exec = "/bin/file";
        args = [
          "${pkgs.file}/share/man/man1/file.1.gz"
          "${pkgs.dejavu_fonts}/share/fonts/truetype/DejaVuMathTeXGyre.ttf"
        ];
        pkgFun = pkgs: platformFun pkgs.file;
      };

    hello =
      {
        platformFun,
        crossPkgs,
        emulator,
      }:
      compareTest {
        inherit emulator crossPkgs;
        hostPkgs = pkgs;
        exec = "/bin/hello";
        pkgFun = pkgs: pkgs.hello;
      };

    pkg-config =
      {
        platformFun,
        crossPkgs,
        emulator,
      }:
      crossPkgs.runCommand "test-pkg-config-${crossPkgs.stdenv.hostPlatform.config}"
        {
          depsBuildBuild = [ crossPkgs.pkgsBuildBuild.pkg-config ];
          nativeBuildInputs = [
            crossPkgs.pkgsBuildHost.pkg-config
            crossPkgs.buildPackages.zlib
          ];
          depsBuildTarget = [ crossPkgs.pkgsBuildTarget.pkg-config ];
          buildInputs = [ crossPkgs.zlib ];
          NIX_DEBUG = 7;
        }
        ''
          mkdir $out
          ${crossPkgs.pkgsBuildBuild.pkg-config.targetPrefix}pkg-config --cflags zlib > "$out/for-build"
          ${crossPkgs.pkgsBuildHost.pkg-config.targetPrefix}pkg-config --cflags zlib > "$out/for-host"
          ! diff "$out/for-build" "$out/for-host"
        '';
  };

  # see https://github.com/NixOS/nixpkgs/issues/213453
  # this is a good test of a lot of tricky glibc/libgcc corner cases
  mbuffer =
    let
      mbuffer = pkgs.pkgsCross.aarch64-multiplatform.mbuffer;
      emulator = with lib.systems; (elaborate examples.aarch64-multiplatform).emulator pkgs;
    in
    pkgs.runCommand "test-mbuffer" { } ''
      echo hello | ${emulator} ${mbuffer}/bin/mbuffer
      touch $out
    '';

  # This is meant to be a carefully curated list of builds/packages
  # that tend to break when refactoring our cross-compilation
  # infrastructure.
  #
  # It should strike a balance between being small enough to fit in
  # a single eval (i.e. not so large that hydra-eval-jobs is needed)
  # so we can ask @ofborg to check it, yet should have good examples
  # of things that often break.  So, no buckshot `mapTestOnCross`
  # calls here.
  sanity =
    [
      mbuffer
      #pkgs.pkgsCross.gnu64.bash # https://github.com/NixOS/nixpkgs/issues/243164
      pkgs.gcc_multi.cc
      pkgs.pkgsMusl.stdenv
      pkgs.pkgsLLVM.stdenv
      pkgs.pkgsStatic.bash
      #pkgs.pkgsCross.gnu64_simplekernel.bash   # https://github.com/NixOS/nixpkgs/issues/264989
      pkgs.pkgsCross.arm-embedded.stdenv
      pkgs.pkgsCross.sheevaplug.stdenv # for armv5tel
      pkgs.pkgsCross.raspberryPi.stdenv # for armv6l
      pkgs.pkgsCross.armv7l-hf-multiplatform.stdenv
      pkgs.pkgsCross.m68k.stdenv
      pkgs.pkgsCross.aarch64-multiplatform.pkgsBuildTarget.gcc
      pkgs.pkgsCross.powernv.pkgsBuildTarget.gcc
      pkgs.pkgsCross.s390.stdenv
      pkgs.pkgsCross.mips64el-linux-gnuabi64.stdenv
      pkgs.pkgsCross.mips64el-linux-gnuabin32.stdenv
      pkgs.pkgsCross.mingwW64.stdenv

    ]
    ++ lib.optionals (with pkgs.stdenv.buildPlatform; isx86_64 && isLinux) [
      # Musl-to-glibc cross on the same architecture tends to turn up
      # lots of interesting corner cases.  Only expected to work for
      # x86_64-linux buildPlatform.
      pkgs.pkgsMusl.pkgsCross.gnu64.hello

      # Two web browsers -- exercises almost the entire packageset
      pkgs.pkgsCross.aarch64-multiplatform.qutebrowser-qt5
      pkgs.pkgsCross.aarch64-multiplatform.firefox

      # Uses pkgsCross.riscv64-embedded; see https://github.com/NixOS/nixpkgs/issues/267859
      pkgs.spike
    ];

in
{
  gcc = (lib.mapAttrs (_: mapMultiPlatformTest (system: system // { useLLVM = false; })) tests);
  llvm = (lib.mapAttrs (_: mapMultiPlatformTest (system: system // { useLLVM = true; })) tests);

  inherit mbuffer sanity;
}
