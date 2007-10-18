{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "smartmontools-5.36";
  
  src = fetchurl {
    url = mirror://sourceforge/smartmontools/smartmontools-5.36.tar.gz;
    sha256 = "1x2bcbyrl5c4djcvnsnasdry498w6slx1gixgynpmlgq4bgjl0zj";
  };

  meta = {
    description = "Tools for monitoring the health of hard drivers";
    homepage = http://smartmontools.sourceforge.net/;
    license = "GPL";
  };
}
