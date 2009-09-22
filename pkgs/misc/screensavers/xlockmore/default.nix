{stdenv, fetchurl, pam ? null, x11, freetype}:

stdenv.mkDerivation rec {
  # FIXME: Password authentication doesn't work!

  name = "xlockmore-5.29";
  src = fetchurl {
    url = "http://www.tux.org/~bagleyd/xlock/${name}/${name}.tar.bz2";
    sha256 = "47700f74cdd6ada80717358fd9cbb4316a0b2350fd527cfcd1e9b018d3818db2";
  };

  # Optionally, it can use GTK+ as well.
  buildInputs = [pam x11 freetype];

  # The `xlock' program needs to be linked against Glibc's
  # `libgcrypt', which contains `crypt(3)'.
  patches = [ ./makefile-libcrypt.patch ];

  # Don't try to install `xlock' setuid.  Instead, the user should add
  # it to `security.extraSetuidPrograms'.
  configureFlags =
    + " --with-crypt"		# TODO: set --enable-appdefaultdir to a suitable value
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
    description = "Xlockmore, a screen locker for the X Window System.";
    homepage = http://www.tux.org/~bagleyd/xlockmore.html;
    license = "GPL";
  };
}
