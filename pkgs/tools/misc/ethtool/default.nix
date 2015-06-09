{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "ethtool-4.0";

  src = fetchurl {
    url = "mirror://kernel/software/network/ethtool/${name}.tar.xz";
    sha256 = "1zzcwn6pk8qfasalqkxg8vrhacksfa50xsq4xifw7yfjqyn8fj4h";
  };

  meta = with stdenv.lib; {
    description = "Utility for controlling network drivers and hardware";
    homepage = https://www.kernel.org/pub/software/network/ethtool/;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
