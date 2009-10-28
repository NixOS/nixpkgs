{ stdenv, fetchurl, libX11, xextproto, libXtst, imake, libXi, libXext }:

stdenv.mkDerivation rec {
  name = "keynav-20070903";

  src = fetchurl {
    url = "http://www.semicomplete.com/files/keynav/${name}.tar.gz";
    sha256 = "037mbgm78jwy0qd0z691pgx4zcpkk5544fx8ajm2mx4y80k2d9kk";
  };

  buildInputs = [libX11 xextproto libXtst imake libXi libXext];

  NIX_LDFLAGS = "-lXext";

  installPhase =
    ''
      mkdir -p $out/bin $out/share/keynav/doc
      cp keynav $out/bin
      cp keynavrc $out/share/keynav/doc
    '';

  meta = {
    description = "A tool to generate X11 mouse clicks from keyboard.";
  };
}
