{ stdenv, fetchurl, ncurses ? null, autoconf, libtool, automake,
gettext, cvs, pkgconfig, ... }:

stdenv.mkDerivation rec {
  name = "util-linux-ng-2.16.2";

#  src = fetchurl {
#    url = "mirror://kernel/linux/utils/util-linux-ng/v2.16/${name}.tar.bz2";
#    sha256 = "1sx3z64z8z95v93k0c9lczcp04zw4nm3d2rkhczkyxcpdfcgbhxi";
#  };

  src = fetchurl {
     url = "file:///home/llbatlle/arm/stdenv-updates/util-linux-ng.tar.gz";
     sha256 = "07ichlan4jqrcz13ldbcrwqn8z28fmj0jz7k4naf1ajyk1l9m4h1";
  };

  configureFlags = ''
    --disable-use-tty-group
    ${if ncurses == null then "--without-ncurses" else ""}
  '';

  buildNativeInputs = [ autoconf libtool automake gettext pkgconfig cvs ];
  buildInputs = stdenv.lib.optional (ncurses != null) ncurses;

  # !!! It would be better to obtain the path to the mount helpers
  # (/sbin/mount.*) through an environment variable, but that's
  # somewhat risky because we have to consider that mount can setuid
  # root...
  preConfigure = ''
    substituteInPlace mount/mount.c --replace /sbin/mount. /var/run/current-system/sw/sbin/mount.
    substituteInPlace mount/umount.c --replace /sbin/umount. /var/run/current-system/sw/sbin/umount.
    sh autogen.sh
    autoreconf -vfi
  '';

}
