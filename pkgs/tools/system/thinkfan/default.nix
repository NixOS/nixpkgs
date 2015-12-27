{ stdenv, fetchurl, cmake }:

stdenv.mkDerivation rec {
  name = "thinkfan-${version}";
  version = "0.9.2";

  src = fetchurl {
    url = "mirror://sourceforge/thinkfan/thinkfan-${version}.tar.gz";
    sha256 = "0ydgabk2758f6j64g1r9vdsd221nqsv5rwnphm81s7i2vgra1nlh";
  };

  nativeBuildInputs = [ cmake ];

  unpackPhase = ''
    sourceRoot="$PWD/${name}";
    mkdir $sourceRoot;
    tar xzvf "$src" -C $sourceRoot;
  '';

  installPhase = ''
    mkdir -p $out/bin;
    mv thinkfan $out/bin/;
  '';

  meta = {
    description = "";
    license = stdenv.lib.licenses.gpl3;
    homepage = "http://thinkfan.sourceforge.net/";
    maintainers = with stdenv.lib.maintainers; [ iElectric ];
    platforms = stdenv.lib.platforms.linux;
  };
}
