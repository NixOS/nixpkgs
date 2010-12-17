{stdenv, fetchurl, disnix, socat, pkgconfig}:

stdenv.mkDerivation {
  name = "disnixos";
  src = fetchurl {
    url = http://hydra.nixos.org/build/811135/download/1/disnixos-0.1pre25150.tar.gz;
    sha256 = "004i4k0c9lfvfmmv5iqwnqk3h2lip166dp8vpn3k3mvmpl17cn3j";
  };
  buildInputs = [ socat pkgconfig disnix ];
  dontStrip = true;
  NIX_STRIP_DEBUG = true;
}
