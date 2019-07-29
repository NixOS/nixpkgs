{ stdenv, lib, fetchgit, darwin, writeText
, git, ninja, python2 }:

let
  rev = "0bc16a82ea001ad9c94b870f097034be5c8e40b4";
  sha256 = "01as6q5xr0smiihm9m1x74pykd2jcqi4rhv8irmv43v2f0pxwzi5";

  shortRev = builtins.substring 0 7 rev;
  lastCommitPosition = writeText "last_commit_position.h" ''
    #ifndef OUT_LAST_COMMIT_POSITION_H_
    #define OUT_LAST_COMMIT_POSITION_H_

    #define LAST_COMMIT_POSITION "(${shortRev})"

    #endif  // OUT_LAST_COMMIT_POSITION_H_
  '';

in
stdenv.mkDerivation rec {
  name = "gn-${version}";
  version = "20190726";

  src = fetchgit {
    url = "https://gn.googlesource.com/gn";
    inherit rev sha256;
  };

  nativeBuildInputs = [ ninja python2 git ];
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
