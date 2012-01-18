{stdenv, fetchurl}:
  
stdenv.mkDerivation {
  name = "chkrootkit-0.48";
  
  src = fetchurl {
    url = ftp://ftp.pangeia.com.br/pub/seg/pac/chkrootkit.tar.gz;
    sha256 = "1yzid6bw092nf8k83y1119kc4ns7r0l3zsfah5xal8kh19ad7cxl";
  };

  installPhase = "
    mkdir -p $out/sbin
    cp check_wtmpx chkdirs chklastlog chkproc chkrootkit chkutmp chkwtmp ifpromisc strings-static $out/sbin
  ";
  
}
