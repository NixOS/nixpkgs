{stdenv, fetchurl, disnix, socat, pkgconfig}:

stdenv.mkDerivation {
  name = "disnixos-0.1pre25636";
  src = fetchurl {
    url = http://hydra.nixos.org/build/895070/download/3/disnixos-0.1pre25636.tar.gz;
    sha256 = "0pizbqzjb7kicb5ghqbmsg7rab3akk6yga4bfnrh3ly2yg6qgw6k";
  };
  buildInputs = [ socat pkgconfig disnix ];
  dontStrip = true;
  NIX_STRIP_DEBUG = true;
}
