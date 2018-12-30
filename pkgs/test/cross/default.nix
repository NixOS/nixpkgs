{ pkgs, lib }:

let

  testedSystems = lib.filterAttrs (name: value: let
    platform = lib.systems.elaborate value;
  in platform.isLinux || platform.isWindows
  ) lib.systems.examples;

  getExecutable = pkgs: pkgFun: exec:
    "${pkgFun pkgs}${exec}${pkgs.hostPlatform.extensions.executable}";

  compareTest = { emulator, pkgFun, hostPkgs, crossPkgs, exec, args ? [] }: let
    pkgName = (pkgFun hostPkgs).name;
    args' = lib.concatStringsSep " " args;
  in pkgs.runCommand "test-${pkgName}-${crossPkgs.hostPlatform.config}" {
    nativeBuildInputs = [ pkgs.dos2unix ];
  } ''
    # Just in case we are using wine, get rid of that annoying extra
    # stuff.
    export WINEDEBUG=-all

    HOME=$(pwd)
    mkdir -p $out

    # We need to remove whitespace, unfortunately
    # Windows programs use \r but Unix programs use \n

    # find expected value natively
    ${getExecutable hostPkgs pkgFun exec} ${args'} \
      | dos2unix > $out/expected

    # run emulator to get actual value
    ${emulator} ${getExecutable crossPkgs pkgFun exec} ${args'} \
      | dos2unix > $out/actual

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

  mapMultiPlatformTest = test: lib.mapAttrs (name: system: test rec {
    crossPkgs = import pkgs.path {
      localSystem = { inherit (pkgs.hostPlatform) config; };
      crossSystem = system;
    };

    emulator = crossPkgs.hostPlatform.emulator pkgs;

    # Apply some transformation on windows to get dlls in the right
    # place. Unfortunately mingw doesn’t seem to be able to do linking
    # properly.
    platformFun = pkg: if crossPkgs.hostPlatform.isWindows then
      pkgs.buildEnv {
        name = "${pkg.name}-winlinks";
        paths = [pkg] ++ pkg.buildInputs;
      } else pkg;
  }) testedSystems;

in

lib.mapAttrs (_: mapMultiPlatformTest) {

  file = {platformFun, crossPkgs, emulator}: compareTest {
    inherit emulator crossPkgs;
    hostPkgs = pkgs;
    exec = "/bin/file";
    args = [
      "${pkgs.file}/share/man/man1/file.1.gz"
      "${pkgs.dejavu_fonts}/share/fonts/truetype/DejaVuMathTeXGyre.ttf"
    ];
    pkgFun = pkgs: platformFun pkgs.file;
  };

  hello = {platformFun, crossPkgs, emulator}: compareTest {
    inherit emulator crossPkgs;
    hostPkgs = pkgs;
    exec = "/bin/hello";
    pkgFun = pkgs: pkgs.hello;
  };

}
