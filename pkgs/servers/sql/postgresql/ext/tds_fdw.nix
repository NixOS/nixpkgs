{ lib, stdenv, fetchFromGitHub, postgresql, freetds }:

stdenv.mkDerivation rec {
  pname = "tds_fdw";
  version = "2.0.2";

  buildInputs = [ postgresql freetds ];

  src = fetchFromGitHub {
    owner  = "tds-fdw";
    repo   =  pname;
    rev    = "refs/tags/v${version}";
    sha256 = "024syj21gmdfkpr51l8ca70n5jimr35zwdy719b8h4zjn64ci1fk";
  };

  installPhase = ''
    install -D tds_fdw.so                  -t $out/lib
    install -D sql/tds_fdw--${version}.sql -t $out/share/postgresql/extension
    install -D tds_fdw.control             -t $out/share/postgresql/extension
  '';

  meta = with lib; {
    description = "A PostgreSQL foreign data wrapper to connect to TDS databases (Sybase and Microsoft SQL Server)";
    homepage    = "https://github.com/tds-fdw/tds_fdw";
    maintainers = [ maintainers.steve-chavez ];
    platforms   = postgresql.meta.platforms;
    license     = licenses.postgresql;
    broken = versionAtLeast postgresql.version "11.0";
  };
}
