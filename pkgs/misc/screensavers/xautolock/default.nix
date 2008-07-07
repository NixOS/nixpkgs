{stdenv, fetchurl, x11, imake, libXScrnSaver, scrnsaverproto}:

stdenv.mkDerivation rec
{
  name = "xautolock-2.1";
  src = fetchurl
  {
    url = "http://www.ibiblio.org.org/pub/Linux/X11/screensavers/${name}.tgz";
    sha256 = "1ylc6589ck88jmp8bxccs0xay1nyrnlw6cajzihk5m0pkfwwk92b";
  };

  makeFlags="BINDIR=$$out/bin MANPATH=$$out/man";
  preBuild = "xmkmf";
  installTargets = "install install.man";
  buildInputs = [x11 imake libXScrnSaver scrnsaverproto];
}
