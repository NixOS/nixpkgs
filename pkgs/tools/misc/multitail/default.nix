{ stdenv, fetchurl, ncurses }:

stdenv.mkDerivation rec {
  name = "multitail-6.2.1";

  src = fetchurl {
    url = "http://www.vanheusden.com/multitail/${name}.tgz";
    sha256 = "049fv5cyl5f7vcc8n2q3z3i5k0sqv2k715ic0s4q1nrw5kb6qn0y";
  };

  buildInputs = [ ncurses ];

  makeFlags = stdenv.lib.optionalString stdenv.isDarwin "-f makefile.macosx";

  installPhase = ''
    mkdir -p $out/bin
    cp multitail $out/bin
  '';

  meta = {
    homepage = http://www.vanheusden.com/multitail/;
    description = "tail on Steroids";
  };
}
