{ stdenv, fetchurl, autoconf, automake, openssl, libxml2 }:

let
  scrypt_src = fetchurl {
    url = "http://masterpasswordapp.com/libscrypt-b12b554.tar.gz";
    sha256 = "02vz4i66v1acd15xjgki4ilmmp28m6a5603gi4hf8id3d3ndl9n7";
  };

in stdenv.mkDerivation {
  name = "mpw-2.1-cli4";

  srcs = [
    (fetchurl {
      url = "https://ssl.masterpasswordapp.com/mpw-2.1-cli4-0-gf6b2287.tar.gz";
      sha256 = "141bzb3nj18rbnbpdvsri8cdwwwxz4d6akyhfa834542xf96b9vf";
    })
    scrypt_src
  ];

  sourceRoot = ".";

  postUnpack = ''
    cp -R libscrypt-b12b554/* lib/scrypt
  '';

  prePatch = ''
    patchShebangs .
  '';

  NIX_CFLAGS_COMPILE = "-I${libxml2.dev}/include/libxml2";

  buildInputs = [ autoconf automake openssl libxml2 ];

  buildPhase = ''
    targets="mpw mpw-tests" ./build
  '';

  installPhase = ''
    mkdir -p $out/bin
    mv mpw $out/bin/mpw
  '';

  meta = {
    platforms = stdenv.lib.platforms.unix;
  };
}
