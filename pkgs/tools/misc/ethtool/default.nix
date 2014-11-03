{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "ethtool-3.16";

  src = fetchurl {
    url = "mirror://kernel/software/network/ethtool/${name}.tar.xz";
    sha256 = "11m2ghjgnbjbvxamgjkr94cw9sz1znla8rkw923svhq4m4zxvq6n";
  };

  meta = with stdenv.lib; {
    description = "Utility for controlling network drivers and hardware";
    homepage = https://www.kernel.org/pub/software/network/ethtool/;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
