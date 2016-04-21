{ stdenv, fetchurl, autoconf, automake, pkgconfig, pcre, xz }:

stdenv.mkDerivation rec {
  name = "ag-0.31.0";

  src = fetchurl {
    url = "https://github.com/ggreer/the_silver_searcher/archive/0.31.0.tar.gz";
    sha256 = "1a3xncsq3x8pci194k484s5mdqij2sirpz6dj6711n2p8mzq5g31";
  };

  buildInputs = [ autoconf automake pkgconfig pcre xz ];

  buildPhase = "./build.sh --prefix $out";

  meta = with stdenv.lib; {
    homepage = "http://geoff.greer.fm/ag";
    description = "A code-searching tool similar to ack, but faster";
    license = licenses.asl20;
  };
}
