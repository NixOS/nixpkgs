{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "ethtool-${version}";
  version = "4.6";

  src = fetchurl {
    url = "mirror://kernel/software/network/ethtool/${name}.tar.xz";
    sha256 = "e90589a9349d008cce8c0510ac4e8878efdc0ddb1b732a9a4cc333b101313415";
  };

  meta = with stdenv.lib; {
    description = "Utility for controlling network drivers and hardware";
    homepage = https://www.kernel.org/pub/software/network/ethtool/;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
