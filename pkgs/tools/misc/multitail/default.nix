{ stdenv, fetchurl, ncurses }:

stdenv.mkDerivation {
  name = "multitail-5.2.12";

  src = fetchurl {
    url = http://www.vanheusden.com/multitail/multitail-5.2.12.tgz;
    sha256 = "681d87cd49e11aab1d82ad7818ee639c88a3d305db8accf0859977beda6c493c";
  };

  buildInputs = [ ncurses ];

  installPhase = ''
    ensureDir $out/bin
    cp multitail $out/bin
  '';

  meta = {
    homepage = http://www.vanheusden.com/multitail/;
    description = "tail on Steroids";
  };
}
