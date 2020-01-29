{ stdenv, lib, fetchgit, darwin, writeText
, git, ninja, python3 }:

let
  rev = "64b846c96daeb3eaf08e26d8a84d8451c6cb712b";
  sha256 = "1v2kzsshhxn0ck6gd5w16gi2m3higwd9vkyylmsczxfxnw8skgpy";

  shortRev = builtins.substring 0 7 rev;
  lastCommitPosition = writeText "last_commit_position.h" ''
    #ifndef OUT_LAST_COMMIT_POSITION_H_
    #define OUT_LAST_COMMIT_POSITION_H_

    #define LAST_COMMIT_POSITION "(${shortRev})"

    #endif  // OUT_LAST_COMMIT_POSITION_H_
  '';

in
stdenv.mkDerivation {
  pname = "gn";
  version = "20190403";

  src = fetchgit {
    url = "https://gn.googlesource.com/gn";
    inherit rev sha256;
  };

  nativeBuildInputs = [ ninja python3 git ];
  buildInputs = lib.optionals stdenv.isDarwin (with darwin; with apple_sdk.frameworks; [
    libobjc
    cctools

    # frameworks
    ApplicationServices
    Foundation
    AppKit
  ]);

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
    description = "A meta-build system that generates NinjaBuild files";
    homepage = https://gn.googlesource.com/gn;
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ stesie matthewbauer ];
  };
}
