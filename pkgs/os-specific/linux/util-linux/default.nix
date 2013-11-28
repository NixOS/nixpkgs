{ stdenv, fetchurl, zlib, ncurses ? null, perl ? null, pam }:
let
  ver = "2.24";
in
stdenv.mkDerivation rec {
  name = "util-linux-${ver}";

  src = fetchurl {
    url = "http://www.kernel.org/pub/linux/utils/util-linux/v${ver}/${name}.tar.bz2";
    sha256 = "1nfnymj03rdcxjb677a9qq1zirppr8csh32cb85qm23x5xndi6v3";
  };

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
    --enable-write
    --enable-last
    --enable-mesg
    --enable-ddate
    --disable-use-tty-group
    --enable-fs-paths-default=/var/setuid-wrappers:/var/run/current-system/sw/sbin:/sbin
    ${if ncurses == null then "--without-ncurses" else ""}
  '';

  buildInputs =
    [ zlib pam ]
    ++ stdenv.lib.optional (ncurses != null) ncurses
    ++ stdenv.lib.optional (perl != null) perl;

  enableParallelBuilding = true;

  meta = {
    homepage = http://www.kernel.org/pub/linux/utils/util-linux/;
    description = "A set of system utilities for Linux";
  };
}
