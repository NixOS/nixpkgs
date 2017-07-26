{ stdenv, fetchurl, xlibsWrapper, imake, libXScrnSaver, scrnsaverproto }:

stdenv.mkDerivation rec {
  name = "xautolock-2.2";
  src = fetchurl {
    url = "http://www.ibiblio.org/pub/Linux/X11/screensavers/${name}.tgz";
    sha256 = "11f0275175634e6db756e96f5713ec91b8b1c41f8663df54e8a5d27dc71c4da2";
  };
  patches = [
    # https://gist.github.com/miekg/9430422
    (fetchurl {
      url = "https://gist.githubusercontent.com/miekg/9430422/raw/f00965cd63c497d320f028a9972d1185b0dae039/14-add-lockaftersleep-patch";
      sha256 = "042lc5yyyl3zszll2l930apysd0lip26w0d0f0gjkl7sbhshgk8v";
    })
  ];
  NIX_CFLAGS_COMPILE = "-DSYSV";
  makeFlags="BINDIR=\${out}/bin MANPATH=\${out}/man";
  preBuild = "xmkmf";
  installTargets = "install install.man";
  buildInputs = [xlibsWrapper imake libXScrnSaver scrnsaverproto];
  meta = with stdenv.lib; {
    description = "A program that launches a given program when your X session has been idle for a given time.";
    homepage = http://www.ibiblio.org/pub/linux/X11/screensavers;
    maintainers = with maintainers; [ garbas ];
    platforms = platforms.linux;
    license = licenses.gpl2;
  };
}
