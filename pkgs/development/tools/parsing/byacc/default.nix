{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "byacc-${version}";
  version = "20170709";

  src = fetchurl {
    urls = [
      "ftp://ftp.invisible-island.net/byacc/${name}.tgz"
      "https://invisible-mirror.net/archives/byacc/${name}.tgz"
    ];
    sha256 = "1syrg1nwh2qmlr5mh7c4vz9psdv4gf55h8i5ffw84q6whlcq1kr7";
  };

  doCheck = true;

  meta = with stdenv.lib; {
    description = "Berkeley YACC";
    homepage = http://invisible-island.net/byacc/byacc.html;
    license = licenses.publicDomain;
    platforms = platforms.unix;
  };
}
