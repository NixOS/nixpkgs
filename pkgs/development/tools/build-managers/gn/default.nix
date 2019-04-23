{ stdenv, lib, fetchgit, fetchzip, fetchpatch, darwin, writeText
, git, ninja, python2 }:

let
  rev = "96ff462cddf35f98e25fd5d098fc27bc81eab94a";
  sha256 = "1ny23sprl7ygb2lpdnqxv60m8kaf4h2dmpqjp61l5vc2s7f32g97";

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
  version = "20181031";

  src = fetchgit {
    url = "https://gn.googlesource.com/gn";
    inherit rev sha256;
  };

  postPatch = ''
    # FIXME Needed with old Apple SDKs
    substituteInPlace base/mac/foundation_util.mm \
      --replace "NSArray<NSString*>*" "NSArray*"
  '';

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
    python build/gen.py --no-sysroot --no-last-commit-position
    ln -s ${lastCommitPosition} out/last_commit_position.h
    ninja -j $NIX_BUILD_CORES -C out gn
  '';

  installPhase = ''
    install -vD out/gn "$out/bin/gn"
  '';

  meta = with lib; {
    description = "A meta-build system that generates NinjaBuild files";
    homepage = https://gn.googlesource.com/gn;
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ stesie matthewbauer ];
  };
}
