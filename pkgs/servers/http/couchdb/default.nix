{ stdenv, fetchurl, erlang, icu, openssl, spidermonkey, curl, help2man, python
, sphinx, which, file, pkgconfig, getopt }:

stdenv.mkDerivation rec {
  name = "couchdb-${version}";
  version = "1.7.1";

  src = fetchurl {
    url = "mirror://apache/couchdb/source/${version}/apache-${name}.tar.gz";
    sha256 = "1b9cbdrmh1i71mrwvhm17v4cf7lckpil1vvq7lpmxyn6zfk0l84i";
  };

  nativeBuildInputs = [ help2man which file pkgconfig sphinx ];
  buildInputs = [ erlang icu openssl spidermonkey curl ];

  postInstall = ''
    substituteInPlace $out/bin/couchdb --replace getopt "${getopt}/bin/getopt"
  '';

  /*
  Versions of SpiderMonkey after the js185-1.0.0 release remove the optional
  enforcement of preventing anonymous functions in a statement context. This
  will most likely break your existing JavaScript code as well as render all
  example code invalid.

  If you wish to ignore this error pass --enable-js-trunk to ./configure.
  */
  configureFlags = ''
    --enable-js-trunk
  '';

  meta = with stdenv.lib; {
    description = "A database that uses JSON for documents, JavaScript for MapReduce queries, and regular HTTP for an API";
    homepage = http://couchdb.apache.org;
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = with maintainers; [ garbas ];
  };
}
