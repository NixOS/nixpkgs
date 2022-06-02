{ lib, stdenv, fetchurl, perl }:

stdenv.mkDerivation rec {
  pname = "bonnie++";
  version = "1.98";

  src = fetchurl {
    url = "https://www.coker.com.au/bonnie++/bonnie++-${version}.tgz";
    sha256 = "010bmlmi0nrlp3aq7p624sfaj5a65lswnyyxk3cnz1bqig0cn2vf";
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
