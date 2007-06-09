{stdenv, fetchurl, gtk, SDL, nasm, zlib, bzip2, libjpeg}:

stdenv.mkDerivation { 
  name = "generator-0.35-cbiere-r3";
  src = fetchurl {
    url = http://www.ghostwhitecrab.com/generator/generator-0.35-cbiere-r3.tar.bz2;
    sha256 = "0jw2ibbjyms9sklapnb6pzkmk680zsqq9pd51r2n4957zv1f36jd";
  };
  configureFlags = "--with-gtk --with-raze --with-sdl-audio";
  buildInputs = [gtk SDL nasm zlib bzip2 libjpeg];
  # Only required when not using SDL audio.
#  patches = [./soundcard.patch];
}
