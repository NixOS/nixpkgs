{ stdenv, fetchurl, ncurses ? null, perl ? null }:

stdenv.mkDerivation rec {
  name = "util-linux-ng-2.18";

  src = fetchurl {
    url = "mirror://kernel/linux/utils/util-linux-ng/v2.18/${name}.tar.bz2";
    sha256 = "1k1in1ba9kvh0kplri9765wh0yk68qrkk1a55dqsm21qfryc1idq";
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
