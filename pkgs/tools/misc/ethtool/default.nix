{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "ethtool-3.11";

  src = fetchurl {
    url = "mirror://kernel/software/network/ethtool/${name}.tar.xz";
    sha256 = "1m1gc2g5ym7xmbq64ysw9avp9bbsagbi7x624mzki5ba3535agym";
  };

  meta = with stdenv.lib; {
    description = "Utility for controlling network drivers and hardware";
    homepage = https://www.kernel.org/pub/software/network/ethtool/;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
