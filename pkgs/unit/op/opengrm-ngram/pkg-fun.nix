{ lib, stdenv, autoreconfHook, fetchurl, openfst }:

stdenv.mkDerivation rec {
  pname = "opengrm-ngram";
  version = "1.3.14";

  src = fetchurl {
    url = "http://www.openfst.org/twiki/pub/GRM/NGramDownload/ngram-${version}.tar.gz";
    sha256 = "sha256-ivMPDy6CPM17hWCToLOVzUgcWZiEt2pjYeizeBLYnYc=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [ openfst ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Library to make and modify n-gram language models encoded as weighted finite-state transducers";
    homepage = "https://www.openfst.org/twiki/bin/view/GRM/NGramLibrary";
    license = licenses.asl20;
    maintainers = with maintainers; [ mic92 ];
    platforms = platforms.unix;
  };
}
