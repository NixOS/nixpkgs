{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "ethtool-${version}";
  version = "4.18";

  src = fetchurl {
    url = "mirror://kernel/software/network/ethtool/${name}.tar.xz";
    sha256 = "0461nwqp1z9a89nmxf7kq0r4jfl9c7fg55c71lfmc5y0siaqb54h";
  };

  meta = with stdenv.lib; {
    description = "Utility for controlling network drivers and hardware";
    homepage = https://www.kernel.org/pub/software/network/ethtool/;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
