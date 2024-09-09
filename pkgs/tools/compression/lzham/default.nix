{ lib, stdenv, fetchFromGitHub, cmake } :

stdenv.mkDerivation rec {
  pname = "lzham";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "richgel999";
    repo = "lzham_codec";
    rev = "v${lib.replaceStrings ["."] ["_"] version}_release";
    sha256 = "14c1zvzmp1ylp4pgayfdfk1kqjb23xj4f7ll1ra7b18wjxc9ja1v";
  };

  nativeBuildInputs = [ cmake ];

  installPhase = ''
    mkdir -p $out/bin
    cp ../bin_linux/lzhamtest $out/bin
  '';

  meta = with lib; {
    description = "Lossless data compression codec with LZMA-like ratios but 1.5x-8x faster decompression speed";
    mainProgram = "lzhamtest";
    homepage = "https://github.com/richgel999/lzham_codec";
    license = with licenses; [ mit ];
    platforms = platforms.linux;
  };
}
