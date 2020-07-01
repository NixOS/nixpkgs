{ stdenv, fetchurl, imake, gccmakedep
, libX11, libXaw, libXext, libXmu, libXpm, libXxf86vm  }:

stdenv.mkDerivation {

  name = "xbrightness-0.3-mika-akk";
  src = fetchurl {
    url = "https://shallowsky.com/software/xbrightness/xbrightness-0.3-mika-akk.tar.gz";
    sha256 = "2564dbd393544657cdabe4cbf535d9cfb9abe8edddb1b8cdb1ed4d12f358626e";
  };

  nativeBuildInputs = [ imake gccmakedep ];
  buildInputs = [ libX11 libXaw libXext libXmu libXpm libXxf86vm ];

  makeFlags = [ "BINDIR=$(out)/bin" "MANPATH=$(out)/share/man" ];
  installTargets = [ "install" "install.man" ];

  meta = {
    description = "X11 brigthness and gamma software control";
    homepage = "http://shallowsky.com/software";
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.linux;
  };
}
