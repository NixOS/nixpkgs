{stdenv, fetchurl, unzip, zlib, SDL}:

stdenv.mkDerivation {
  name = "atari800-2.0.2";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://surfnet.dl.sourceforge.net/sourceforge/atari800/atari800-2.0.2.tar.gz;
    md5 = "a81f8a5ace5fd89eb6094faef7c936af";
  };
  rom = fetchurl {
    url = http://surfnet.dl.sourceforge.net/sourceforge/atari800/xf25.zip;
    md5 = "4dc3b6b4313e9596c4d474785a37b94d";
  };
  buildInputs = [unzip zlib SDL];
  configureFlags = "--target=sdl";
}
