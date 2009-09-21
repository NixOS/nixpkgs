args: with args; with kde;

stdenv.mkDerivation {
  name = "partitionmanager-1.0.0";

  src = fetchurl {
    url = http://www.kde-apps.org/CONTENT/content-files/89595-partitionmanager-1.0.0.tar.bz2;
    sha256 = "03ibn4vns7pa0ygkp2jh6zcdy106as5cc7p6rv1f5c15wxx0zsk1";
  };

  buildInputs = [cmake gettext parted libuuid
      qt kdelibs kdebase automoc4 perl phonon];

  preConfigure = ''
    export VERBOSE=1
    cmakeFlagsArray=($cmakeFlagsArray -DGETTEXT_INCLUDE_DIR=${gettext}/include -DCMAKE_INCLUDE_PATH=${qt}/include/QtGui )
  '';

  postInstall = ''
    set -x
    rpath=`patchelf --print-rpath $out/bin/partitionmanager-bin`:${qt}/lib 
    for p in $out/bin/partitionmanager-bin; do
      patchelf --set-rpath $rpath $p
    done
  '';

  meta = { 
    description = "utility program to help you manage the disk devices";
    homepage = http://www.kde-apps.org/content/show.php/KDE+Partition+Manager?content=89595; # ?
    license = "GPL";
    #maintainers = [args.lib.maintainers.marcweber];
    platforms = args.lib.platforms.linux;
  };
}
