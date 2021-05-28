{ stdenv, fetchFromGitHub, postgresql, perl, cmake, boost }:

stdenv.mkDerivation rec {
  pname = "pgrouting";
  version = "3.1.0";

  nativeBuildInputs = [ cmake perl ];
  buildInputs = [ postgresql boost ];

  src = fetchFromGitHub {
    owner  = "pgRouting";
    repo   = pname;
    rev    = "v${version}";
    sha256 = "0sdyq0a98snmcq6g6mgmadlz6cgvacivv34943azhnzspa3iy409";
  };

  installPhase = ''
    install -D lib/*.so                        -t $out/lib
    install -D sql/pgrouting--${version}.sql   -t $out/share/postgresql/extension
    install -D sql/common/pgrouting.control    -t $out/share/postgresql/extension
  '';

  meta = with stdenv.lib; {
    description = "A PostgreSQL/PostGIS extension that provides geospatial routing functionality";
    homepage    = "https://pgrouting.org/";
    maintainers = [ maintainers.steve-chavez ];
    platforms   = postgresql.meta.platforms;
    license     = licenses.gpl2;
  };
}
