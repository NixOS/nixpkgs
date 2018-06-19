{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "ethtool-${version}";
  version = "4.17";

  src = fetchurl {
    url = "mirror://kernel/software/network/ethtool/${name}.tar.xz";
    sha256 = "11f5503mgcwjn1q4dvhjiqwnw3zmp2gbhirjvgfr71y72ys1wsy4";
  };

  meta = with stdenv.lib; {
    description = "Utility for controlling network drivers and hardware";
    homepage = https://www.kernel.org/pub/software/network/ethtool/;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
