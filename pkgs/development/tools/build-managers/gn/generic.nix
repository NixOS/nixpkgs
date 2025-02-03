{ stdenv, lib, fetchgit, cctools, darwin, writeText
, ninja, python3
, ...
}:

{ rev, revNum, version, sha256 }:

let
  revShort = builtins.substring 0 7 rev;
  lastCommitPosition = writeText "last_commit_position.h" ''
    #ifndef OUT_LAST_COMMIT_POSITION_H_
    #define OUT_LAST_COMMIT_POSITION_H_

    #define LAST_COMMIT_POSITION_NUM ${revNum}
    #define LAST_COMMIT_POSITION "${revNum} (${revShort})"

    #endif  // OUT_LAST_COMMIT_POSITION_H_
  '';

in stdenv.mkDerivation {
  pname = "gn-unstable";
  inherit version;

  src = fetchgit {
    # Note: The TAR-Archives (+archive/${rev}.tar.gz) are not deterministic!
    url = "https://gn.googlesource.com/gn";
    inherit rev sha256;
  };

  nativeBuildInputs = [ ninja python3 ];
  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin (with darwin; with apple_sdk.frameworks; [
    libobjc
    cctools

    # frameworks
    ApplicationServices
    Foundation
    AppKit
  ]);

  env.NIX_CFLAGS_COMPILE = "-Wno-error";

  buildPhase = ''
    python build/gen.py --no-last-commit-position
    ln -s ${lastCommitPosition} out/last_commit_position.h
    ninja -j $NIX_BUILD_CORES -C out gn
  '';

  installPhase = ''
    install -vD out/gn "$out/bin/gn"
  '';

  setupHook = ./setup-hook.sh;

  meta = with lib; {
    description = "Meta-build system that generates build files for Ninja";
    mainProgram = "gn";
    homepage = "https://gn.googlesource.com/gn";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ stesie matthewbauer primeos ];
  };
}
