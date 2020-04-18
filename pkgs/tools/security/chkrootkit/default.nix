{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "chkrootkit-0.53";

  src = fetchurl {
    url = "ftp://ftp.pangeia.com.br/pub/seg/pac/${name}.tar.gz";
    sha256 = "1da5ry3p7jb6xs6xlfml1ly09q2rs5q6n5axif17d29k7gixlqkj";
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

  meta = with stdenv.lib; {
    description = "Locally checks for signs of a rootkit";
    homepage = "http://www.chkrootkit.org/";
    license = licenses.bsd2;
    platforms = with platforms; linux;
  };
}
