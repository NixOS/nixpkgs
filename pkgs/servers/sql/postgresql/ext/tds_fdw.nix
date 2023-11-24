{ lib, stdenv, fetchFromGitHub, postgresql, freetds, unstableGitUpdater }:

stdenv.mkDerivation rec {
  pname = "tds_fdw";
  # Move to stable version when it's released.
  version = "unstable-2023-09-28";

  buildInputs = [ postgresql freetds ];

  src = fetchFromGitHub {
    owner  = "tds-fdw";
    repo   = "tds_fdw";
    rev    = "22ee5d3f46909b35efb2600b44ec19a35179630e";
    hash   = "sha256-MmaLN1OWUJMWJhPUXBevSyBmMgZqeEFPGuxuLPSp4Pk=";
  };

  installPhase = ''
    version="$(sed -En "s,^default_version *= *'([^']*)'.*,\1,p" tds_fdw.control)"
    install -D tds_fdw${postgresql.dlSuffix} -t $out/lib
    install -D sql/tds_fdw.sql    "$out/share/postgresql/extension/tds_fdw--$version.sql"
    install -D tds_fdw.control -t $out/share/postgresql/extension
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    description = "A PostgreSQL foreign data wrapper to connect to TDS databases (Sybase and Microsoft SQL Server)";
    homepage    = "https://github.com/tds-fdw/tds_fdw";
    maintainers = [ maintainers.steve-chavez ];
    platforms   = postgresql.meta.platforms;
    license     = licenses.postgresql;
  };
}
