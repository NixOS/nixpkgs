{ lib, stdenv, fetchurl, bzip2 }:

let major = "1.1";
    version = "${major}.13";
in
stdenv.mkDerivation rec {
  pname = "pbzip2";
  inherit version;

  src = fetchurl {
    url = "https://launchpad.net/pbzip2/${major}/${version}/+download/${pname}-${version}.tar.gz";
    sha256 = "1rnvgcdixjzbrmcr1nv9b6ccrjfrhryaj7jwz28yxxv6lam3xlcg";
  };

  buildInputs = [ bzip2 ];

  preBuild = "substituteInPlace Makefile --replace g++ c++";

  installFlags = [ "PREFIX=$(out)" ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isClang "-Wno-error=reserved-user-defined-literal";

  meta = with lib; {
    homepage = "http://compression.ca/pbzip2/";
    description = "A parallel implementation of bzip2 for multi-core machines";
    license = licenses.bsd2;
    maintainers = with maintainers; [viric];
    platforms = platforms.unix;
  };
}
