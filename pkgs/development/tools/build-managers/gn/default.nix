{ stdenv, lib, fetchgit, fetchzip, fetchpatch, darwin, writeText
, git, ninja, python }:

let
  rev = "106b823805adcc043b2bfe5bc21d58f160a28a7b";
  sha256 = "1a5s6i07s8l4f1bakh3fyaym00xz7zgd49sp6awm10xb7yjh95ba";

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
  version = "20180830";

  src = fetchgit {
    url = "https://gn.googlesource.com/gn";
    inherit rev sha256;
  };

  postPatch = ''
    # FIXME Needed with old Apple SDKs
    substituteInPlace base/mac/foundation_util.mm \
      --replace "NSArray<NSString*>*" "NSArray*"
  '';

  nativeBuildInputs = [ ninja python git ];
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
