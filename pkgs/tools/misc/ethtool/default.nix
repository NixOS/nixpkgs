{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "ethtool-3.15";

  src = fetchurl {
    url = "mirror://kernel/software/network/ethtool/${name}.tar.xz";
    sha256 = "16kgw9y4fisldf1z6zpw3v965cc8nram0dycacwkc0js4l76klw8";
  };

  meta = with stdenv.lib; {
    description = "Utility for controlling network drivers and hardware";
    homepage = https://www.kernel.org/pub/software/network/ethtool/;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
