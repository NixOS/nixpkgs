{ stdenv, fetchgit, cmake, automoc4, kdelibs, libbluedevil, shared_mime_info }:

stdenv.mkDerivation rec {
  name = "bluedevil-20110303";

  src = fetchgit {
    url = git://anongit.kde.org/bluedevil.git;
    sha256 = "1chx3cx43wic1sgzc651vxxiy9khbp9hcm7n40nmhnj9czfcg46q";
    rev = "7e513008aa6430d3b8d0052b14201d1d813c80b9";
  };

  buildInputs = [ cmake kdelibs libbluedevil shared_mime_info automoc4 ];

}
