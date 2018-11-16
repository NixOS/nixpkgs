{ stdenv, fetchurl, pkgconfig, python3, sqlite, libedit, zlib }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  version = "5.5.1";
  pname = "link-grammar";

  outputs = [ "bin" "out" "dev" "man" ];

  src = fetchurl {
    url = "http://www.abisource.com/downloads/${pname}/${version}/${name}.tar.gz";
    sha256 = "1x8kj1yr3b7b6qrvc5b8mm90ff3m4qdbdqplvzii2xlkpvik92ff";
  };

  nativeBuildInputs = [ pkgconfig python3 ];
  buildInputs = [ sqlite libedit zlib ];

  configureFlags = [
    "--disable-java-bindings"
  ];

  meta = with stdenv.lib; {
    description = "A Grammar Checking library";
    homepage = https://www.abisource.com/projects/link-grammar/;
    license = licenses.lgpl21;
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.unix;
  };
}
