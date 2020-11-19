{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "cksfv-1.3.15";

  src = fetchurl {
    url = "http://zakalwe.fi/~shd/foss/cksfv/files/${name}.tar.bz2";
    sha256 = "0k06aq94cn5xp4knjw0p7gz06hzh622ql2xvnrlr3q8rcmdvwwx1";
  };

  meta = with stdenv.lib; {
    homepage = "http://zakalwe.fi/~shd/foss/cksfv/";
    description = "A tool for verifying files against a SFV checksum file";
    platforms = platforms.all;
    license = licenses.gpl2;
  };
}
