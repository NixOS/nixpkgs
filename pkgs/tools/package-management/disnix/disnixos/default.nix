{stdenv, fetchurl, disnix, socat, pkgconfig}:

stdenv.mkDerivation {
  name = "disnixos-0.1pre25259";
  src = fetchurl {
    url = http://hydra.nixos.org/build/825090/download/1/disnixos-0.1pre25259.tar.gz;
    sha256 = "0g1pjw2f7jacp8kd9q90bihvr3s3cz9l19ddjfajc0harall61ms";
  };
  buildInputs = [ socat pkgconfig disnix ];
  dontStrip = true;
  NIX_STRIP_DEBUG = true;
}
