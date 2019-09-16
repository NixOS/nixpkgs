{ stdenv, fetchFromGitHub, postgresql, perl, cmake, boost, gmp, cgal, mpfr }:

stdenv.mkDerivation rec {
  pname = "pgrouting";
  version = "2.6.3";

  nativeBuildInputs = [ cmake perl ];
  buildInputs = [ postgresql boost gmp cgal mpfr ];

  src = fetchFromGitHub {
    owner  = "pgRouting";
    repo   = pname;
    rev    = "v${version}";
    sha256 = "0jdjb8476vjgc7i26v2drcqjvhdbsk1wx243fddffg169nb664ml";
  };

  installPhase = ''
    install -D lib/*.so                        -t $out/lib
    install -D sql/pgrouting--${version}.sql   -t $out/share/postgresql/extension
    install -D sql/common/pgrouting.control    -t $out/share/postgresql/extension
  '';

  meta = with stdenv.lib; {
    description = "A PostgreSQL/PostGIS extension that provides geospatial routing functionality";
    homepage    = https://pgrouting.org/;
    maintainers = [ maintainers.steve-chavez ];
    platforms   = postgresql.meta.platforms;
    license     = licenses.gpl2;
  };
}
