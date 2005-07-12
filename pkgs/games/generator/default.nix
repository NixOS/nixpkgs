{stdenv, fetchurl, gtk, SDL, nasm}:

stdenv.mkDerivation {
  name = "generator-0.35-cbiere-20050503";
  src = fetchurl {
    url = http://www.ghostwhitecrab.com/generator/generator-0.35-cbiere.tar.bz2;
    md5 = "bce3326c165d74e8a00e50355b653e08";
  };
  configureFlags = "--with-gtk --with-raze --with-sdl-audio";
  buildInputs = [gtk SDL nasm];
  # Only required when not using SDL audio.
#  patches = [./soundcard.patch];
}
