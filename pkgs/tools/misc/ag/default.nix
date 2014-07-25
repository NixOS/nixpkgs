{ stdenv, fetchurl, unzip, autoconf, automake, pcre, pkgconfig, xz}:

stdenv.mkDerivation rec {
  name = "ag-${version}";
  version = "0.23.0";

  src = fetchurl {
    url = "https://github.com/ggreer/the_silver_searcher/archive/${version}.zip";
    sha256 = "e1447d87328284b1a3e4f86ca412171e22dba665657504696596a6216394469e";
  };

  buildInputs = [ unzip autoconf automake pcre pkgconfig xz ];

  configureScript="./build.sh";

  buildPhase=""; # is already triggered by ./build.sh in configurePhase

  meta = {
    homepage = "https://github.com/ggreer/the_silver_searcher";
    description = "The Silver Searcher is a highspeed replacement for 'ack' (which is a replacement for grep)";
    license = stdenv.lib.licenses.asl20;
  };
}
