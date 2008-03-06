{stdenv, fetchurl, pam, x11, freetype}:

stdenv.mkDerivation {
  # FIXME: Password authentication doesn't work!

  name = "xlockmore-5.24";
  src = fetchurl {
    url = http://www.tux.org/~bagleyd/xlock/xlockmore-5.24.tar.bz2;
    sha256 = "dbee7bbe35c08afcbe419603fae60aee7898bbd85a3175dc788f02ddbb9f5a39";
  };

  # Optionally, it can use GTK+ as well.
  buildInputs = [pam x11 freetype];

  # The `xlock' program needs to be linked against Glibc's
  # `libgcrypt', which contains `crypt(3)'.
  patches = [ ./makefile-libcrypt.patch ];

  # Don't try to install `xlock' setuid.  Instead, the user should add
  # it to `security.extraSetuidPrograms'.
  configureFlags = 
    "--disable-setuid --enable-pam --enable-bad-pam " +
    "--enable-appdefaultdir=$out/lib/X11/app-defaults";

  meta = {
    description = "Xlockmore, a screen locker for the X Window System.";
    homepage = http://www.tux.org/~bagleyd/xlockmore.html;
    license = "GPL";
  };
}
