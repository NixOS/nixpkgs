{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "byacc-${version}";
  version = "20180525";

  src = fetchurl {
    urls = [
      "ftp://ftp.invisible-island.net/byacc/${name}.tgz"
      "https://invisible-mirror.net/archives/byacc/${name}.tgz"
    ];
    sha256 = "1ridghk1xprxfg2k8ls87wjc00i4a7f39x2fkswfqb2wwf5qv6qj";
  };

  doCheck = true;

  meta = with stdenv.lib; {
    description = "Berkeley YACC";
    homepage = http://invisible-island.net/byacc/byacc.html;
    license = licenses.publicDomain;
    platforms = platforms.unix;
  };
}
