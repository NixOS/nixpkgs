{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "chkrootkit-0.54";

  src = fetchurl {
    url = "ftp://ftp.pangeia.com.br/pub/seg/pac/${name}.tar.gz";
    sha256 = "sha256-FUySaSH1PbYHKKfLyXyohli2lMFLfSiO/jg+CEmRVgc=";
  };

  # TODO: a lazy work-around for linux build failure ...
  makeFlags = [ "STATIC=" ];

   postPatch = ''
    substituteInPlace chkrootkit \
      --replace " ./" " $out/bin/"
   '';

  installPhase = ''
    mkdir -p $out/sbin
    cp check_wtmpx chkdirs chklastlog chkproc chkrootkit chkutmp chkwtmp ifpromisc strings-static $out/sbin
  '';

  meta = with lib; {
    description = "Locally checks for signs of a rootkit";
    homepage = "http://www.chkrootkit.org/";
    license = licenses.bsd2;
    platforms = with platforms; linux;
  };
}
