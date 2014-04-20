{ stdenv, fetchurl, ncurses }:

stdenv.mkDerivation {
  name = "multitail-5.2.13";

  src = fetchurl {
    url = http://www.vanheusden.com/multitail/multitail-5.2.13.tgz;
    sha256 = "1axgbdm1xkg570j0p150492x7p3mf11shwvn6dz8g4rha7cak4l6";
  };

  buildInputs = [ ncurses ];

  makeFlags = stdenv.lib.optionalString stdenv.isDarwin "-f makefile.macosx";

  installPhase = ''
    ensureDir $out/bin
    cp multitail $out/bin
  '';

  meta = {
    homepage = http://www.vanheusden.com/multitail/;
    description = "tail on Steroids";
  };
}
