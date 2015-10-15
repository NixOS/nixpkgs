{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "chkrootkit-0.50";

  src = fetchurl {
    url = ftp://ftp.pangeia.com.br/pub/seg/pac/chkrootkit-0.50.tar.gz;
    sha256 = "1ivclp7ixndacjmf7xgj8lfa6h7ihx44mzzsapqdvf0c5f9gqj4m";
  };

  installPhase = "
    mkdir -p $out/sbin
    cp check_wtmpx chkdirs chklastlog chkproc chkrootkit chkutmp chkwtmp ifpromisc strings-static $out/sbin
  ";
}
