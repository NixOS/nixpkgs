{ stdenv, fetchurl, pam ? null, x11 }:

stdenv.mkDerivation rec {

  name = "xlockmore-5.43";
  src = fetchurl {
    url = "http://www.tux.org/~bagleyd/xlock/${name}/${name}.tar.bz2";
    sha256 = "1l36n8x51j7lwdalv6yi37cil290vzd3djjqydhsm0pnm8hiz499";
  };

  # Optionally, it can use GTK+.
  buildInputs = [ pam x11 ];

  # The `xlock' program needs to be linked against Glibc's
  # `libgcrypt', which contains `crypt(3)'.
  patches = [ ./makefile-libcrypt.patch ];

  # Don't try to install `xlock' setuid. Password authentication works
  # fine via PAM without super user privileges.
  configureFlags =
      " --with-crypt"		# TODO: set --enable-appdefaultdir to a suitable value
    + " --disable-setuid"
    + " --without-editres"
    + " --without-xpm"
    + " --without-gltt"
    + " --without-ttf"
    + " --without-ftgl"
    + " --without-freetype"
    + " --without-opengl"
    + " --without-mesa"
    + " --without-dtsaver"
    + " --without-ext"
    + " --without-dpms"
    + " --without-xinerama"
    + " --without-rplay"
    + " --without-nas"
    + " --without-gtk2"
    + " --without-gtk"
    + (if pam != null then " --enable-pam --enable-bad-pam" else " --disable-pam");

  meta = {
    description = "Screen locker for the X Window System";
    homepage = "http://www.tux.org/~bagleyd/xlockmore.html";
    license = "GPL";
  };
}
