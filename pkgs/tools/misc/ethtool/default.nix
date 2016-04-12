{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "ethtool-4.5";

  src = fetchurl {
    url = "mirror://kernel/software/network/ethtool/${name}.tar.xz";
    sha256 = "0fyakzpcrjb7hkaj9ccpcgza7r2im17qzxy9w6xzbiss5hrk8a5v";
  };

  meta = with stdenv.lib; {
    description = "Utility for controlling network drivers and hardware";
    homepage = https://www.kernel.org/pub/software/network/ethtool/;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
