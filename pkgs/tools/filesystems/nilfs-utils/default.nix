{ stdenv, fetchurl, libuuid, libselinux }:
let 
  sourceInfo = rec {
    version = "2.2.3";
    url = "http://nilfs.sourceforge.net/download/nilfs-utils-${version}.tar.bz2";
    sha256 = "1sv0p5d9ivik7lhrdynf6brma66llcvn11zhzasws12n4sfk6k6q";
    baseName = "nilfs-utils";
    name = "${baseName}-${version}";
  };
in
stdenv.mkDerivation rec {
  src = fetchurl {
    url = sourceInfo.url;
    sha256 = sourceInfo.sha256;
  };

  inherit (sourceInfo) name version;
  buildInputs = [libuuid libselinux];

  preConfigure = ''
    sed -e '/sysconfdir=\/etc/d; ' -i configure
    sed -e "s@sbindir=/sbin@sbindir=$out/sbin@" -i configure
    sed -e 's@/sbin/@'"$out"'/sbin/@' -i ./lib/cleaner*.c
  '';

  meta = {
    description = "NILFS utilities";
    maintainers = with stdenv.lib.maintainers;
    [
      raskin
    ];
    platforms = with stdenv.lib.platforms;
      linux;
    downloadPage = "http://nilfs.sourceforge.net/en/download.html";
    updateWalker = true;
    inherit version;
  };
}
