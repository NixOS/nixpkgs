{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "ethtool-3.13";

  src = fetchurl {
    url = "mirror://kernel/software/network/ethtool/${name}.tar.xz";
    sha256 = "07z7janzj8fbs04sw6nlzr039yh7b5gmzvik7ymg807i2gi5fmjs";
  };

  meta = with stdenv.lib; {
    description = "Utility for controlling network drivers and hardware";
    homepage = https://www.kernel.org/pub/software/network/ethtool/;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
