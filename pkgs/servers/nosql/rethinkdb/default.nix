{ stdenv, fetchurl, which, protobuf, v8_3_14, ncurses, gperftools, boost, m4 }:

stdenv.mkDerivation rec {
  name = "rethinkdb-1.11.2";

  src = fetchurl {
    url = "http://download.rethinkdb.com/dist/${name}.tgz";
    sha256 = "04wz07y891vygc5ksrvkk1ch05xj16nahv20bnxwcllkbl4gf9lj";
  };

  preConfigure = ''
    export ALLOW_WARNINGS=1
    patchShebangs .
  '';

  configureFlags = "--lib-path ${gperftools}/lib";

  buildInputs = [ protobuf v8_3_14 ncurses boost ];

  nativeBuildInputs = [ which m4 ];


  meta = {
    description = "An open-source distributed database built with love";
    longDescription = ''
      RethinkDB is built to store JSON documents, and scale to multiple machines with very little
      effort. It has a pleasant query language that supports really useful queries like table joins
      and group by, and is easy to setup and learn.
    '';
    homepage = http://www.rethinkdb.com;
    license = "AGPLv3";

    maintainers = [ stdenv.lib.maintainers.bluescreen303 ];
    platforms = stdenv.lib.platforms.all;
  };
}
