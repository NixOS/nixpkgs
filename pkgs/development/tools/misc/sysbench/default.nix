{ stdenv, fetchgit, libmysql, libxslt, zlib, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "sysbench-2015-04-22";

  buildInputs = [ autoreconfHook libmysql libxslt zlib ];

  src = fetchgit {
    url = git://github.com/akopytov/sysbench.git;
    rev = "2b3042883090c9cf8cb9be2b24d3590cdcee112f";
    sha256 = "1xlb3fracha3wva3dmmjk36b262vblynkmiz8n0mn1vkc78bssaw";
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
