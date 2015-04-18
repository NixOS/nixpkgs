{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "ethtool-3.18";

  src = fetchurl {
    url = "mirror://kernel/software/network/ethtool/${name}.tar.xz";
    sha256 = "1xj20fr44dk01hghyy5sq962sbiywc88ni3qqliv8bfxzmczwgw1";
  };

  meta = with stdenv.lib; {
    description = "Utility for controlling network drivers and hardware";
    homepage = https://www.kernel.org/pub/software/network/ethtool/;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
