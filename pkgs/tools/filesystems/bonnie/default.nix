{ lib, stdenv, fetchurl, perl }:

stdenv.mkDerivation rec {
  pname = "bonnie++";
  version = "2.00a";

  src = fetchurl {
    url = "https://www.coker.com.au/bonnie++/bonnie++-${version}.tgz";
    sha256 = "sha256-qNM7vYG8frVZzlv25YS5tT+uo5zPtK6S5Y8nJX5Gjw4=";
  };

  enableParallelBuilding = true;

  buildInputs = [ perl ];

  meta = {
    homepage = "http://www.coker.com.au/bonnie++/";
    description = "Hard drive and file system benchmark suite";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
