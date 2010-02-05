{ stdenv, fetchurl, ncurses ? null, ... }:

stdenv.mkDerivation rec {
  name = "util-linux-ng-2.16.2";

  src = fetchurl {
    url = "mirror://kernel/linux/utils/util-linux-ng/v2.16/${name}.tar.bz2";
    sha256 = "1sx3z64z8z95v93k0c9lczcp04zw4nm3d2rkhczkyxcpdfcgbhxi";
  };

  configureFlags = ''
    --disable-use-tty-group
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
