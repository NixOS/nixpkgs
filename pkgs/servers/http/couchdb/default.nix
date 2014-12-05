{ stdenv, fetchurl, erlang, icu, openssl, spidermonkey, curl, help2man, python
, sphinx, which, file, pkgconfig, getopt }:

stdenv.mkDerivation rec {
  name = "couchdb-${version}";
  version = "1.6.1";

  src = fetchurl {
    url = "mirror://apache/couchdb/source/${version}/apache-${name}.tar.gz";
    sha256 = "09w6ijj9l5jzh81nvc3hrlqp345ajg3haj353g9kxkik6wbinq2s";
  };

  buildInputs = [ erlang icu openssl spidermonkey curl help2man sphinx which
    file pkgconfig ];

  postInstall = ''
    sed -i -e "s|\`getopt|\`${getopt}/bin/getopt|" $out/bin/couchdb
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

  meta = {
    description = "A database that uses JSON for documents, JavaScript for MapReduce queries, and regular HTTP for an API";
    homepage = "http://couchdb.apache.org";
    license = stdenv.lib.licenses.asl20;
    maintainers = with stdenv.lib.maintainers; [ viric garbas ];
  };
}
