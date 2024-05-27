{ lib, mkDerivation }:

mkDerivation {
  path = "lib/libossaudio";
  version = "9.2";
  sha256 = "16l3bfy6dcwqnklvh3x0ps8ld1y504vf57v9rx8f9adzhb797jh0";
  meta.platforms = lib.platforms.netbsd;
}
