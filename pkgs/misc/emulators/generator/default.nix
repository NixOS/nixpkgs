{stdenv, fetchurl, gtk, SDL, nasm}:

stdenv.mkDerivation { 
  name = "generator-0.35-cbiere-r2";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/generator-0.35-cbiere-r2.tar.bz2;
    md5 = "2076c20e0ad1b20d9ac15cab8cb12ad5";
  };
  configureFlags = "--with-gtk --with-raze --with-sdl-audio";
  buildInputs = [gtk SDL nasm];
  # Only required when not using SDL audio.
#  patches = [./soundcard.patch];
}
