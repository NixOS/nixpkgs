{ stdenv, fetchurl }:
stdenv.mkDerivation rec {
  pname = "crc-reveng";
  version = "2.1.0";

  src = fetchurl {
    url = "mirror://sourceforge/reveng/${version}/reveng-${version}.tar.xz";
    sha256 = "0d13w6xp47zdsz8x2sxm1708i6h0bis1q5b49bbw032mwk8jpklx";
  };

  patchPhase = ''
    substituteInPlace config.h --replace "BMP_BIT   32" "BMP_BIT 64"
    substituteInPlace config.h --replace "BMP_SUB   16" "BMP_SUB 32"
  '';

  buildPhase = "make";

  installPhase = ''
    mkdir -p $out/bin
    cp ./reveng $out/bin
  '';

  meta = with stdenv.lib; {
    description = "Arbitrary-precision CRC calculator and algorithm finder";
    homepage = "http://reveng.sourceforge.net/";
    maintainers = with maintainers; [ btlvr ];
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
