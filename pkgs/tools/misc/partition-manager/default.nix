{ stdenv, fetchurl, pkgconfig, cmake, gettext, automoc4, perl
, parted, libuuid, qt4, kdelibs, kde_baseapps, phonon, libatasmart
}:

stdenv.mkDerivation rec {
  name = "partitionmanager-1.0.3_p20120804";

  src = fetchurl {
    #url = "mirror://sourceforge/partitionman/${name}.tar.bz2";
    # the upstream version is old and doesn't build
    url = "http://dev.gentoo.org/~kensington/distfiles/${name}.tar.bz2";
    sha256 = "1j6zpgj8xs98alzxvcibwch9yj8jsx0s7y864gbdx280jmj8c1np";
  };

  buildInputs = [
    pkgconfig cmake gettext automoc4 perl
    parted libuuid qt4 kdelibs kde_baseapps phonon libatasmart
  ];

  preConfigure = ''
    export VERBOSE=1
    cmakeFlagsArray=($cmakeFlagsArray -DGETTEXT_INCLUDE_DIR=${gettext}/include -DCMAKE_INCLUDE_PATH=${qt4}/include/QtGui )
  '';

  postInstall = ''
    set -x
    rpath=`patchelf --print-rpath $out/bin/partitionmanager-bin`:${qt4}/lib
    for p in $out/bin/partitionmanager-bin; do
      patchelf --set-rpath $rpath $p
    done
  '';

  meta = {
    description = "Utility program to help you manage the disk devices";
    homepage = http://www.kde-apps.org/content/show.php/KDE+Partition+Manager?content=89595; # ?
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
  };
}
