{ lib, stdenv, fetchFromGitHub, postgresql, perl, cmake, boost }:

stdenv.mkDerivation rec {
  pname = "pgrouting";
  version = "3.6.3";

  nativeBuildInputs = [ cmake perl ];
  buildInputs = [ postgresql boost ];

  src = fetchFromGitHub {
    owner  = "pgRouting";
    repo   = "pgrouting";
    rev    = "v${version}";
    hash   = "sha256-VCoapUM7Vh4W1DUE/gWQ9YIRLbw63XlOWsgajJW+XNU=";
  };

  installPhase = ''
    install -D lib/*.so                        -t $out/lib
    install -D sql/pgrouting--${version}.sql   -t $out/share/postgresql/extension
    install -D sql/common/pgrouting.control    -t $out/share/postgresql/extension
  '';

  meta = with lib; {
    description = "PostgreSQL/PostGIS extension that provides geospatial routing functionality";
    homepage    = "https://pgrouting.org/";
    changelog   = "https://github.com/pgRouting/pgrouting/releases/tag/v${version}";
    maintainers = with maintainers; teams.geospatial.members ++ [ steve-chavez ];
    platforms   = postgresql.meta.platforms;
    license     = licenses.gpl2Plus;
  };
}
