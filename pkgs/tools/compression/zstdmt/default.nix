{ stdenv, fetchFromGitHub, zstd, lz4 }:

stdenv.mkDerivation rec {
  name = "zstdmt-${version}";
  version = "0.3";

  src = fetchFromGitHub {
    sha256 = "17i44kjc612sbs7diim9ih007zp7z9zs3q3yacd6dzlqya5vsp0w";
    rev = "v${version}";
    repo = "zstdmt";
    owner = "mcmilk";
  };

  sourceRoot = "zstdmt-v${version}-src/unix";

  buildInputs = [
    zstd lz4
  ];

  buildPhase = ''
    make zstdmt lz4mt
  '';

  installPhase = ''
    mkdir -p $out/bin/
    mv zstdmt lz4mt $out/bin/
  '';

  meta = with stdenv.lib; {
    description = "Multithreading Library for LZ4, LZ5 and ZStandard";
    homepage = https://github.com/mcmilk/zstdmt;
    license = with licenses; [ bsd2 ];

    platforms = platforms.unix;
  };
}
