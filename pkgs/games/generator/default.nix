{stdenv, fetchurl, gtk, SDL, nasm}:

stdenv.mkDerivation {
  name = "generator-0.35-cbiere";
  src = fetchurl {
    url = http://www.ghostwhitecrab.com/generator/generator-0.35-cbiere.tar.bz2;
    md5 = "6ec4379d8c6c794ec59b9d61e73fb73d";
  };
  configureFlags = "--with-gtk --with-raze --with-sdl-audio";
  buildInputs = [gtk SDL nasm];
  # Only required when not using SDL audio.
#  patches = [./soundcard.patch];
}
