{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "ethtool-3.10";

  src = fetchurl {
    url = "mirror://kernel/software/network/ethtool/${name}.tar.xz";
    sha256 = "0h0wvi0s6s80v26plkh66aiyybpfyi18sjg5pl9idrd0ccdr93gq";
  };

  meta = with stdenv.lib; {
    description = "Utility for controlling network drivers and hardware";
    homepage = https://www.kernel.org/pub/software/network/ethtool/;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
