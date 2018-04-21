{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "ethtool-${version}";
  version = "4.15";

  src = fetchurl {
    url = "mirror://kernel/software/network/ethtool/${name}.tar.xz";
    sha256 = "06pr3s7wg2pbvfbf7js61bgh3caff4qf50nqqk3cgz9z90rgvxvi";
  };

  meta = with stdenv.lib; {
    description = "Utility for controlling network drivers and hardware";
    homepage = https://www.kernel.org/pub/software/network/ethtool/;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
