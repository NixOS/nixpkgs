{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "byacc-${version}";
  version = "20170201";

  src = fetchurl {
    urls = [
      "ftp://invisible-island.net/byacc/${name}.tgz"
      "http://invisible-mirror.net/archives/byacc/${name}.tgz"
    ];
    sha256 = "90b768d177f91204e6e7cef226ae1dc7cac831b625774cebd3e233a917754f91";
  };

  doCheck = true;

  meta = with stdenv.lib; {
    description = "Berkeley YACC";
    homepage = http://invisible-island.net/byacc/byacc.html;
    license = licenses.publicDomain;
    platforms = platforms.unix;
  };
}
