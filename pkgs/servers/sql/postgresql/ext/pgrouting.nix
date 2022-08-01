{ lib, stdenv, fetchFromGitHub, postgresql, perl, cmake, boost }:

stdenv.mkDerivation rec {
  pname = "pgrouting";
  version = "3.3.1";

  nativeBuildInputs = [ cmake perl ];
  buildInputs = [ postgresql boost ];

  src = fetchFromGitHub {
    owner  = "pgRouting";
    repo   = pname;
    rev    = "v${version}";
    sha256 = "sha256-QOIuJM0d1l56ESzTjtm5IIiZx+2oYrO5mIhkAD8kFpQ=";
  };

  installPhase = ''
    install -D lib/*.so                        -t $out/lib
    install -D sql/pgrouting--${version}.sql   -t $out/share/postgresql/extension
    install -D sql/common/pgrouting.control    -t $out/share/postgresql/extension
  '';

  meta = with lib; {
    description = "A PostgreSQL/PostGIS extension that provides geospatial routing functionality";
    homepage    = "https://pgrouting.org/";
    changelog   = "https://github.com/pgRouting/pgrouting/releases/tag/v${version}";
    maintainers = [ maintainers.steve-chavez ];
    platforms   = postgresql.meta.platforms;
    license     = licenses.gpl2Plus;
  };
}
