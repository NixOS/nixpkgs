{ lib, stdenv
, fetchurl
, pkgs
<<<<<<< HEAD
, buildPackages
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, fixDarwinDylibNames
}:
stdenv.mkDerivation rec {
  pname = "build2-bootstrap";
  version = "0.15.0";
  src = fetchurl {
    url = "https://download.build2.org/${version}/build2-toolchain-${version}.tar.xz";
    sha256 = "1i1p52fr5sjs5yz6hqhljwhc148mvs4fyq0cf7wjg5pbv9wzclji";
  };
  patches = [
    # Pick up sysdirs from NIX_LDFLAGS
    ./nix-ldflags-sysdirs.patch
  ];

  sourceRoot = "build2-toolchain-${version}/build2";
  makefile = "bootstrap.gmake";
  enableParallelBuilding = true;

  setupHook = ./setup-hook.sh;

  strictDeps = true;

  propagatedBuildInputs = lib.optionals stdenv.targetPlatform.isDarwin [
    fixDarwinDylibNames
<<<<<<< HEAD

    # Build2 needs to use lld on Darwin because it creates thin archives when it detects `llvm-ar`,
    # which ld64 does not support.
    (lib.getBin buildPackages.llvmPackages_16.lld)
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  doCheck = true;
  checkPhase = ''
    runHook preCheck
    build2/b-boot --version
    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall
    install -D build2/b-boot $out/bin/b
    runHook postInstall
  '';

<<<<<<< HEAD
  postFixup = ''
    substituteInPlace $out/nix-support/setup-hook \
      --subst-var-by isTargetDarwin '${toString stdenv.targetPlatform.isDarwin}'
  '';

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  inherit (pkgs.build2) passthru;
}
