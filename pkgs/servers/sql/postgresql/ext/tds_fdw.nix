{ lib, stdenv, fetchFromGitHub, postgresql, freetds, unstableGitUpdater }:

stdenv.mkDerivation rec {
  pname = "tds_fdw";
  # Move to stable version when it's released.
  version = "unstable-2023-07-20";

  buildInputs = [ postgresql freetds ];

  src = fetchFromGitHub {
    owner  = "tds-fdw";
    repo   = "tds_fdw";
    rev    = "2323efe2007d012b043fe91ea97a736b85eddce3";
    hash   = "sha256-QdIQVQvOIY8dPi5KcbPQ/9crtD59hXstKOkHRfM1kNI=";
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
