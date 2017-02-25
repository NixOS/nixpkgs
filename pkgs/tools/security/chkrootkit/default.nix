{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "chkrootkit-0.51";

  src = fetchurl {
    url = "ftp://ftp.pangeia.com.br/pub/seg/pac/${name}.tar.gz";
    sha256 = "0y0kbhy8156y8zli0wcqbakb9rprzl1w7jn0kw3xjfgzrgsncqgn";
  };

  # TODO: a lazy work-around for linux build failure ...
  makeFlags = [ "STATIC=" ];

  installPhase = ''
    mkdir -p $out/sbin
    cp check_wtmpx chkdirs chklastlog chkproc chkrootkit chkutmp chkwtmp ifpromisc strings-static $out/sbin
  '';

  meta = with stdenv.lib; {
    description = "Locally checks for signs of a rootkit";
    homepage = http://www.chkrootkit.org/;
    license = licenses.bsd2;
    platforms = with platforms; linux;
  };
}
