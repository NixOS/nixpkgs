{stdenv, fetchurl, zlib, SDL, cmake}:

let
  name = "hatari-1.6.2";
in
stdenv.mkDerivation {
  inherit name; 
  src = fetchurl {
    url = "http://download.tuxfamily.org/hatari/1.6.2/${name}.tar.bz2";
    sha256 = "0gqvfqqd0lg3hi261rwh6gi2b5kmza480kfzx43d4l49xcq09pi0";
  };
  buildInputs = [zlib SDL cmake];
  meta = {
    homepage = "http://hatari.tuxfamily.org/";
    description = "Hatari is an Atari ST/STE/TT/Falcon emulator.";
    license = "GPLv2+";
    platforms = with stdenv.lib.platforms; all;
  };
}
