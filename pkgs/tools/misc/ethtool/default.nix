{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "ethtool-3.14";

  src = fetchurl {
    url = "mirror://kernel/software/network/ethtool/${name}.tar.xz";
    sha256 = "01v7a757757bk68vvap2x0v6jbqicchnjxvh52w8dccixxq2nkj3";
  };

  meta = with stdenv.lib; {
    description = "Utility for controlling network drivers and hardware";
    homepage = https://www.kernel.org/pub/software/network/ethtool/;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
