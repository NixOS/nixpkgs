{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "ethtool";
  version = "5.3";

  src = fetchurl {
    url = "mirror://kernel/software/network/ethtool/${pname}-${version}.tar.xz";
    sha256 = "1i14zrg4a84zjpwvqi8an0zx0hm06g614a79zc2syrkhrvdw1npk";
  };

  meta = with stdenv.lib; {
    description = "Utility for controlling network drivers and hardware";
    homepage = https://www.kernel.org/pub/software/network/ethtool/;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
