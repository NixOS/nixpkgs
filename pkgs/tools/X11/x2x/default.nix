{ stdenv, fetchurl, imake, libX11, libXtst, libXext, gccmakedep }:

stdenv.mkDerivation {
  name = "x2x-1.27";

  src = fetchurl {
    url = "http://github.com/downloads/dottedmag/x2x/x2x-1.27.tar.gz";
    sha256 = "0dha0kn1lbc4as0wixsvk6bn4innv49z9a0sm5wlx4q1v0vzqzyj";
  };

  nativeBuildInputs = [ imake gccmakedep ];
  buildInputs = [ libX11 libXtst libXext ];

  hardeningDisable = [ "format" ];

  buildFlags = [ "x2x" ];

  installPhase = ''
    install -D x2x $out/bin/x2x
    install -D x2x.1 $out/man/man1/x2x.1
  '';

  meta = with stdenv.lib; {
    description = "Allows the keyboard, mouse on one X display to be used to control another X display";
    homepage = https://github.com/dottedmag/x2x;
    license = licenses.bsd3;
    platforms = platforms.linux;
  };
}
