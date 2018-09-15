{ stdenv, lib, fetchgit, fetchzip, fetchpatch, darwin
, git, ninja, python }:

stdenv.mkDerivation rec {
  name = "gn-${version}";
  version = "20180830";

  src = fetchgit {
    url = "https://gn.googlesource.com/gn";
    rev = "106b823805adcc043b2bfe5bc21d58f160a28a7b";
    leaveDotGit = true;  # gen.py uses "git describe" to generate last_commit_position.h
    deepClone = true;
    sha256 = "00xl7rfcwyig23q6qnqzv13lvzm3n30di242zcz2m9rdlfspiayb";
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
    python build/gen.py --no-sysroot
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
