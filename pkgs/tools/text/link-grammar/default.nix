{ stdenv, fetchurl, pkgconfig, python3, sqlite, libedit, zlib }:

stdenv.mkDerivation rec {
  version = "5.6.2";
  pname = "link-grammar";

  outputs = [ "bin" "out" "dev" "man" ];

  src = fetchurl {
    url = "http://www.abisource.com/downloads/${pname}/${version}/${pname}-${version}.tar.gz";
    sha256 = "1jc6j5kxdv3y4mm82q0rrjvlak8p26fqh92dzw5bkwxnvjmjjg1k";
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
