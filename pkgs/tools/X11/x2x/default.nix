{stdenv, fetchurl, imake, libX11, libXtst, libXext}:

stdenv.mkDerivation {
  name = "x2x-1.27";

  src = fetchurl {
    url = "http://github.com/downloads/dottedmag/x2x/x2x-1.27.tar.gz";
    sha256 = "0dha0kn1lbc4as0wixsvk6bn4innv49z9a0sm5wlx4q1v0vzqzyj";
  };

  buildInputs = [ imake libX11 libXtst libXext ];

  configurePhase = ''
    xmkmf
    makeFlags="BINDIR=$out/bin x2x"
  '';

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/man/man1
    cp x2x $out/bin/
    cp x2x.1 $out/man/man1/
  '';

  meta = {
    description = "Allows the keyboard, mouse on one X display to be used to control another X display";
    homepage = http://x2x.dottedmag.net;
    license = "BSD";
  };
}
