{
  lib,
  stdenv,
  fetchurl,
  ncurses,
  postgresql,
}:

stdenv.mkDerivation rec {
  pname = "pg_top";
  version = "3.7.0";

  src = fetchurl {
    url = "https://pgfoundry.org/frs/download.php/1781/pg_top-${version}.tar.gz";
    sha256 = "17xrv0l58rv3an06gkajzw0gg6v810xx6vl137an1iykmhvfh7h2";
  };

  buildInputs = [
    ncurses
    postgresql
  ];

  meta = with lib; {
    description = "A 'top' like tool for PostgreSQL";
    longDescription = ''
      pg_top allows you to:
       * View currently running SQL statement of a process.
       * View query plan of a currently running SQL statement.
       * View locks held by a process.
       * View user table statistics.
       * View user index statistics.
    '';

    homepage = "http://ptop.projects.postgresql.org/";
    platforms = platforms.linux;
    license = licenses.free; # see commands.c
    mainProgram = "pg_top";
  };
}
