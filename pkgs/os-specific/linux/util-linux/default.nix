{ stdenv, fetchurl, zlib, ncurses ? null, perl ? null, pam }:

stdenv.mkDerivation rec {
  name = "util-linux-2.25";

  src = fetchurl {
    url = "http://www.kernel.org/pub/linux/utils/util-linux/v2.25/${name}.tar.xz";
    sha256 = "02lqww6ck4p47wzc883zdjb1gnwm59hsay4hd5i55mfdv25mmfj7";
  };

  outputs = [ "dev" "out" "bin" ]; # ToDo: problems with e2fsprogs

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

  makeFlags = "usrbin_execdir=$(bin)/bin usrsbin_execdir=$(bin)/sbin";

  buildInputs =
    [ zlib pam ]
    ++ stdenv.lib.optional (ncurses != null) ncurses
    ++ stdenv.lib.optional (perl != null) perl;

  postInstall = ''
    sed "s,$out$out,$out,g" -i "$dev"/lib/pkgconfig/*.pc
    rm "$bin/bin/su" # su should be supplied by the su package (shadow)
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = http://www.kernel.org/pub/linux/utils/util-linux/;
    description = "A set of system utilities for Linux";
    license = licenses.gpl2; # also contains parts under more permissive licenses
    platforms = platforms.all;
  };
}

