{ stdenv, fetchurl, zlib, ncurses ? null, perl ? null }:

stdenv.mkDerivation rec {
  name = "util-linux-2.20.1";

  src = fetchurl {
    # This used to be mirror://kernel/linux/utils/util-linux, but it
    # disappeared in the kernel.org meltdown.
    url = "mirror://gentoo/distfiles/${name}.tar.bz2";
    sha256 = "1q5vjcvw4f067c63vj2n3xggvk5prm11571x6vnqiav47vdbqvni";
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
  configureFlags = ''
    --disable-use-tty-group
    --enable-write
    --enable-fs-paths-default=/var/run/current-system/sw/sbin:/sbin
    ${if ncurses == null then "--without-ncurses" else ""}
  '';

  buildInputs = [ zlib ] ++ stdenv.lib.optional (ncurses != null) ncurses
             ++ stdenv.lib.optional (perl != null) perl;
}
