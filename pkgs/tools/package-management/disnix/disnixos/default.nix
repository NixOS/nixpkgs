{stdenv, fetchurl, disnix, socat, pkgconfig}:

stdenv.mkDerivation {
  name = "disnixos";
  src = fetchurl {
    url = http://hydra.nixos.org/build/812969/download/1/disnixos-0.1pre25198.tar.gz;
    sha256 = "1bvn89177cb2ab3vl1lva99hy3r6dznmv7x5hnxmmqncw5kmd42j";
  };
  buildInputs = [ socat pkgconfig disnix ];
  dontStrip = true;
  NIX_STRIP_DEBUG = true;
}
