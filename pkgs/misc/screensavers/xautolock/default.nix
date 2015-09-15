{stdenv, fetchurl, xlibsWrapper, imake, libXScrnSaver, scrnsaverproto}:

stdenv.mkDerivation rec
{
  name = "xautolock-2.2";
  src = fetchurl
  {
    url = "http://www.ibiblio.org/pub/Linux/X11/screensavers/${name}.tgz";
    sha256 = "11f0275175634e6db756e96f5713ec91b8b1c41f8663df54e8a5d27dc71c4da2";
  };
  makeFlags="BINDIR=\${out}/bin MANPATH=\${out}/man";
  preBuild = "xmkmf";
  installTargets = "install install.man";
  buildInputs = [xlibsWrapper imake libXScrnSaver scrnsaverproto];
}
