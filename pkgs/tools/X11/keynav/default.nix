{stdenv, fetchurl, libX11, xextproto, libXtst, imake,
libXi, libXext}:
stdenv.mkDerivation {
  name = "keynav";

  src = fetchurl {
    url = http://www.semicomplete.com/projects/keynav/keynav.tar.gz;
    sha256 = "1b7xppwbl07vrhdp6vszmnhbpsbmqwbna0aymbq5hv315rmkgh20";
  };

  buildInputs = [libX11 xextproto libXtst imake libXi libXext];

  buildPhase = "xmkmf ; make includes ; touch keynav.man ; make ; ";
  installFlags = "BINDIR=$(out)/bin MANDIR=$(out)/man ";

  meta ={
	description = "A tool to generate X11 mouse clicks from keyboard.";
  };
}
