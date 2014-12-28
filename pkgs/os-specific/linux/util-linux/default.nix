{ stdenv, fetchurl, zlib, ncurses ? null, perl ? null, pam }:

stdenv.mkDerivation rec {
  name = "util-linux-2.25.2";

  src = fetchurl {
    url = "mirror://kernel/linux/utils/util-linux/v2.25/${name}.tar.xz";
    sha256 = "e0457f715b73f4a349e1acb08cb410bf0edc9a74a3f75c357070f31f70e33cd6";
  };

  crossAttrs = {
    # Work around use of `AC_RUN_IFELSE'.
    preConfigure = "export scanf_cv_type_modifier=ms";
  };

  # !!! It would be better to obtain the path to the mount helpers
  # (/sbin/mount.*) through an environment variable, but that's
  # somewhat risky because we have to consider that mount can setuid
  # root...
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

  postInstall = ''
    rm $out/bin/su # su should be supplied by the su package (shadow)
  '';

  enableParallelBuilding = true;

  meta = {
    homepage = http://www.kernel.org/pub/linux/utils/util-linux/;
    description = "A set of system utilities for Linux";
  };
}
