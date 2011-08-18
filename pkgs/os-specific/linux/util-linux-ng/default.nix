{ stdenv, fetchurl, ncurses ? null, perl ? null }:

stdenv.mkDerivation rec {
  version = "2.19.1";
  name = "util-linux-ng-2.19.1";

  src = fetchurl {
    url = "mirror://kernel/linux/utils/util-linux-ng/v2.19/util-linux-${version}.tar.bz2";
    sha256 = "d3eac4afcc687b3ae1ffedcab2dc12df84c7ba7045cce31386d2b7040a011c7d";
  };

  # !!! It would be better to obtain the path to the mount helpers
  # (/sbin/mount.*) through an environment variable, but that's
  # somewhat risky because we have to consider that mount can setuid
  # root...
  configureFlags = ''
    --disable-use-tty-group
    --enable-write
    --enable-fs-paths-default=/var/run/current-system/sw/sbin:/sbin
    ${if ncurses == null then "--without-ncurses" else ""}
  '';

  buildInputs = stdenv.lib.optional (ncurses != null) ncurses
             ++ stdenv.lib.optional (perl != null) perl;
}
