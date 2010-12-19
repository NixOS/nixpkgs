{stdenv, fetchurl, disnix, socat, pkgconfig}:

stdenv.mkDerivation {
  name = "disnixos";
  src = fetchurl {
    url = http://hydra.nixos.org/build/812999/download/1/disnixos-0.1pre25200.tar.gz;
    sha256 = "1cw0wg5x65nanrjfj67nk1jxngaqh2l7msx03s536hssm9g2mv7r";
  };
  buildInputs = [ socat pkgconfig disnix ];
  dontStrip = true;
  NIX_STRIP_DEBUG = true;
}
