{stdenv, fetchurl, coreutils}:

stdenv.mkDerivation {
  name = "findutils-4.2.30";
  src = fetchurl {
    url = ftp://ftp.nluug.nl/pub/gnu/findutils/findutils-4.2.30.tar.gz;
    sha256 = "1x1s0h1gf4hxh6xi6vq336sz8zsh4hvnsslc7607z41l82xrqjrl";
  };
  buildInputs = [coreutils];
  patches = [ ./findutils-path.patch ./change_echo_path.patch ]
  
    # Note: the dietlibc patch is just to get findutils to compile.
    # The locate command probably won't work though.
    ++ stdenv.lib.optional (stdenv ? isDietLibC) ./dietlibc-hack.patch;
}
