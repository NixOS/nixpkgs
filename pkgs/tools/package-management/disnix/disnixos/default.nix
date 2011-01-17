{stdenv, fetchurl, disnix, socat, pkgconfig}:

stdenv.mkDerivation {
  name = "disnixos-0.1pre25606";
  src = fetchurl {
    url = http://hydra.nixos.org/build/860037/download/1/disnixos-0.1pre25606.tar.gz;
    sha256 = "1rsajzn79ca1624zsj9zr72247hh3gdda53l4vzqb8hzm2vhh0yc";
  };
  buildInputs = [ socat pkgconfig disnix ];
  dontStrip = true;
  NIX_STRIP_DEBUG = true;
}
