{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "ethtool";
  version = "5.4";

  src = fetchurl {
    url = "mirror://kernel/software/network/${pname}/${pname}-${version}.tar.xz";
    sha256 = "0srbqp4a3x9ryrbm5q854375y04ni8j0bmsrl89nmsyn4x4ixy12";
  };

  meta = with stdenv.lib; {
    description = "Utility for controlling network drivers and hardware";
    homepage = https://www.kernel.org/pub/software/network/ethtool/;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
