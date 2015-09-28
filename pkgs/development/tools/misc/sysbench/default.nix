{ stdenv, fetchgit, libmysql, libxslt, zlib, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "sysbench-2015-04-22";

  buildInputs = [ autoreconfHook libmysql libxslt zlib ];

  src = fetchgit {
    url = git://github.com/akopytov/sysbench.git;
    rev = "2b3042883090c9cf8cb9be2b24d3590cdcee112f";
    sha256 = "0di6jc9ybnqk3pqg45lks2c9003l74xz4g619haw36fvbi28aql6";
  };

  preAutoreconf = ''
    touch NEWS AUTHORS
  '';

  meta = {
    description = "Modular, cross-platform and multi-threaded benchmark tool";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
  };
}
