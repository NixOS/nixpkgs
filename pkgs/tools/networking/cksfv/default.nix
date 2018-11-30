{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "cksfv-1.3.14";

  src = fetchurl {
    url = "http://zakalwe.fi/~shd/foss/cksfv/files/${name}.tar.bz2";
    sha256 = "0lnz0z57phl6s52hjvlryn96xrlph9b0h89ahhv027sa79pj8g4g";
  };

  meta = with stdenv.lib; {
    homepage = http://zakalwe.fi/~shd/foss/cksfv/;
    description = "A tool for verifying files against a SFV checksum file";
    platforms = platforms.all;
    license = licenses.gpl2;
  };
}
