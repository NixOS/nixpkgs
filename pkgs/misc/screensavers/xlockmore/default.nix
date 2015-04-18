{ stdenv, fetchurl, pam ? null, x11 }:

stdenv.mkDerivation rec {

  name = "xlockmore-5.46";
  src = fetchurl {
    url = "http://www.tux.org/~bagleyd/xlock/${name}.tar.xz";
    sha256 = "1ps0dmnh912x8mwns94y2607xk90rjxrjn5s1pkmmpjg5h9bxcrj";
  };

  # Optionally, it can use GTK+.
  buildInputs = [ pam x11 ];

  # Don't try to install `xlock' setuid. Password authentication works
  # fine via PAM without super user privileges.
  configureFlags =
      " --with-crypt"
    + " --enable-appdefaultdir=$out/share/X11/app-defaults"
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

  preConfigure = ''
    configureFlags+=" --enable-appdefaultdir=$out/share/X11/app-defaults"
  '';

  meta = with stdenv.lib; {
    description = "Screen locker for the X Window System";
    homepage = http://www.tux.org/~bagleyd/xlockmore.html;
    license = licenses.gpl2;
    maintainers = with maintainers; [ pSub ];
    platforms = platforms.linux;
  };
}
