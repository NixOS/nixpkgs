{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "ethtool-${version}";
  version = "5.1";

  src = fetchurl {
    url = "mirror://kernel/software/network/ethtool/${name}.tar.xz";
    sha256 = "11rkvb1nga9hdiycw0hjn6lh1sfy4p4yzcl4fw5jjrb5xhgsrzk5";
  };

  meta = with stdenv.lib; {
    description = "Utility for controlling network drivers and hardware";
    homepage = https://www.kernel.org/pub/software/network/ethtool/;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
