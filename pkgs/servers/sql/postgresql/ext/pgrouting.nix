{ lib, stdenv, fetchFromGitHub, postgresql, perl, cmake, boost }:

stdenv.mkDerivation rec {
  pname = "pgrouting";
  version = "3.6.1";

  nativeBuildInputs = [ cmake perl ];
  buildInputs = [ postgresql boost ];

  src = fetchFromGitHub {
    owner  = "pgRouting";
    repo   = pname;
    rev    = "v${version}";
    hash   = "sha256-DyrBVGBLUkg0ODuHV3mCkyod2/hEtpZfLSvnrEQObaI=";
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
    maintainers = with maintainers; teams.geospatial.members ++ [ steve-chavez ];
    platforms   = postgresql.meta.platforms;
    license     = licenses.gpl2Plus;
  };
}
