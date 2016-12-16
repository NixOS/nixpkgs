{ me   ? "0e4fbc0d4821f4b2c89b2f9c54f9da398753ae1e"
, base ? "1c50bdd928cec055d2ca842e2cf567aba2584efc"
}:

rec {
  inherit me base;

  myNixpkgsFunc = import ./.; #import (builtins.fetchTarball "https://github.com/Ericson2314/nixpkgs/archive/${me}.tar.gz");
  myNixpkgs = myNixpkgsFunc {};

  baseNixpkgsFunc = import <nixpkgs>; #import (builtins.fetchTarball "https://github.com/NixOS/nixpkgs/archive/${base}.tar.gz");
  baseNixpkgs = baseNixpkgsFunc {};

  #myTestsPass = (import ./nixpkgs/test/cross_system.nix).testsPass;

  gcc6Same = myNixpkgs.gcc6 == baseNixpkgs.gcc6;
  gcc5Same = myNixpkgs.gcc5 == baseNixpkgs.gcc5;
  gcc49Same = myNixpkgs.gcc49 == baseNixpkgs.gcc49;
  gcc48Same = myNixpkgs.gcc48 == baseNixpkgs.gcc48;
  gcc45Same = myNixpkgs.gcc45 == baseNixpkgs.gcc45;
  gccSame = gcc6Same && gcc5Same && gcc49Same && gcc45Same;

  helloSame = rpiHello myNixpkgsFunc == rpiHello baseNixpkgsFunc;

  customStdenv = npf: args: npf ({ config.replaceStdenv = { pkgs }: pkgs.stdenv // { inherit (pkgs) asdf; }; } // args);

  helloCustomStdenv = rpiHello (customStdenv myNixpkgsFunc) == rpiHello (customStdenv baseNixpkgsFunc);
  ghcCustomStdenv = (customStdenv myNixpkgsFunc {}).ghc == (customStdenv baseNixpkgsFunc {}).ghc;

  darwinArgs = { system = "x86_64-darwin"; };
  linuxArgs = { system = "x86_64-linux"; };
  ghcDarwin = (myNixpkgsFunc darwinArgs).ghc == (baseNixpkgsFunc darwinArgs).ghc;
  ghcLinux = (myNixpkgsFunc linuxArgs).ghc == (baseNixpkgsFunc linuxArgs).ghc;

  testsPass = gccSame && helloSame && helloCustomStdenv && ghcCustomStdenv
    && ghcDarwin && ghcLinux;

  rpiHello = nixpkgsFunc: let
      rpiCrossSystem = {
        config = "armv6l-unknown-linux-gnueabi";
        bigEndian = false;
        arch = "arm";
        float = "hard";
        fpu = "vfp";
        withTLS = true;
        libc = "glibc";
        platform = myNixpkgs.platforms.raspberrypi;
        openssl.system = "linux-generic32";
        gcc = {
          arch = "armv6";
          fpu = "vfp";
          float = "softfp";
          abi = "aapcs-linux";
        };
      };
      rpiPkgs = nixpkgsFunc { crossSystem = rpiCrossSystem; };
    in rpiPkgs.hello.crossDrv;
}
