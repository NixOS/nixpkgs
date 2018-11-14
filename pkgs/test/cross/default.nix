{ pkgs, pkgsCross, lib }:

let

  emulators = {
    mingw32 = "WINEDEBUG=-all ${pkgs.winePackages.minimal}/bin/wine";
    mingwW64 = "WINEDEBUG=-all ${pkgs.wineWowPackages.minimal}/bin/wine";
    # TODO: add some qemu-based emulaltors here
  };

  getExecutable = pkgs: pkgFun: exec:
    "${pkgFun pkgs}${exec}${pkgs.hostPlatform.extensions.executable}";

  compareTest = { emulator, pkgFun, hostPkgs, crossPkgs, exec, args ? [] }: let
    pkgName = (pkgFun hostPkgs).name;
    args' = lib.concatStringsSep " " args;
  in pkgs.runCommand "test-${pkgName}-${crossPkgs.hostPlatform.config}" {
    nativeBuildInputs = [ pkgs.dos2unix ];
  } ''
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

in

lib.mapAttrs (name: emulator: let
  crossPkgs = pkgsCross.${name};

  # Apply some transformation on windows to get dlls in the right
  # place. Unfortunately mingw doesn’t seem to be able to do linking
  # properly.
  platformFun = pkg: if crossPkgs.hostPlatform.isWindows then
    pkgs.buildEnv {
      name = "${pkg.name}-winlinks";
      paths = [pkg] ++ pkg.buildInputs;
    } else pkg;
in {

  hello = compareTest {
    inherit emulator crossPkgs;
    hostPkgs = pkgs;
    exec = "/bin/hello";
    pkgFun = pkgs: pkgs.hello;
  };

  file = compareTest {
    inherit emulator crossPkgs;
    hostPkgs = pkgs;
    exec = "/bin/file";
    args = [
      "${pkgs.file}/share/man/man1/file.1.gz"
      "${pkgs.dejavu_fonts}/share/fonts/truetype/DejaVuMathTeXGyre.ttf"
    ];
    pkgFun = pkgs: platformFun pkgs.file;
  };

}) emulators
