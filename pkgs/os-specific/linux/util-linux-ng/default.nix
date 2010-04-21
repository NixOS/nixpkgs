{ stdenv, fetchurl, ncurses ? null, ... }:

stdenv.mkDerivation rec {
  name = "util-linux-ng-2.17.1";

  src = fetchurl {
    url = "mirror://kernel/linux/utils/util-linux-ng/v2.17/${name}.tar.bz2";
    sha256 = "140k32jqg9192vskdb3p98q99qgr14029h975nw21p426zm1kh79";
  };

  configureFlags = ''
    --disable-use-tty-group
    --enable-write
    ${if ncurses == null then "--without-ncurses" else ""}
  '';

  buildInputs = stdenv.lib.optional (ncurses != null) ncurses;

  # !!! It would be better to obtain the path to the mount helpers
  # (/sbin/mount.*) through an environment variable, but that's
  # somewhat risky because we have to consider that mount can setuid
  # root...
  preConfigure = ''
    substituteInPlace mount/mount.c --replace /sbin/mount. /var/run/current-system/sw/sbin/mount.
    substituteInPlace mount/umount.c --replace /sbin/umount. /var/run/current-system/sw/sbin/umount.
  '';

}
