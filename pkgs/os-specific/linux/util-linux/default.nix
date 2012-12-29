{ stdenv, fetchurl, zlib, ncurses ? null, perl ? null }:

stdenv.mkDerivation rec {
  name = "util-linux-2.21.2";

  src = fetchurl {
    url = "http://www.kernel.org/pub/linux/utils/util-linux/v2.21/${name}.tar.bz2";
    sha256 = "0c1xp9pzwizxfk09anvjaz5cv8gvxracvvb6s84xiaxza679svq6";
  };

  patches = [ ./linux-specific-header.patch ];

  crossAttrs = {
    # Work around use of `AC_RUN_IFELSE'.
    preConfigure = "export scanf_cv_type_modifier=ms";
  };

  # !!! It would be better to obtain the path to the mount helpers
  # (/sbin/mount.*) through an environment variable, but that's
  # somewhat risky because we have to consider that mount can setuid
  # root...
  # --enable-libmount-mount  fixes the behaviour being /etc/mtab a symlink to /proc/monunts
  #     http://pl.digipedia.org/usenet/thread/19513/1924/
  configureFlags = ''
    --disable-use-tty-group
    --enable-write
    --enable-fs-paths-default=/var/setuid-wrappers:/var/run/current-system/sw/sbin:/sbin
    --enable-libmount-mount
    ${if ncurses == null then "--without-ncurses" else ""}
  '';

  buildInputs = [ zlib ] ++ stdenv.lib.optional (ncurses != null) ncurses
             ++ stdenv.lib.optional (perl != null) perl;
}
