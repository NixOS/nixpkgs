{stdenv, fetchurl, disnix, socat, pkgconfig}:

stdenv.mkDerivation {
  name = "disnixos-0.1pre25628";
  src = fetchurl {
    url = http://hydra.nixos.org/build/861183/download/1/disnixos-0.1pre25628.tar.gz;
    sha256 = "1wbd8x3j8mspv5v2w5vmfadby52337xpyhjll15a2wik1d8f19bk";
  };
  buildInputs = [ socat pkgconfig disnix ];
  dontStrip = true;
  NIX_STRIP_DEBUG = true;
}
