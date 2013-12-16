{stdenv, fetchurl, ncurses, postgresql}:

stdenv.mkDerivation {
  name = "pg_top-3.7.0";

  src = fetchurl {
    url = http://pgfoundry.org/frs/download.php/1781/pg_top-3.7.0.tar.gz;
    sha256 = "17xrv0l58rv3an06gkajzw0gg6v810xx6vl137an1iykmhvfh7h2";
  };

  buildInputs = [ncurses postgresql]; 

  meta = {
    description = "pg_top is 'top' for PostgreSQL";
    longDescription = '' 
      pg_top allows you to: 
      <itemizedlist>
        <listitem>View currently running SQL statement of a process.</listitem>
        <listitem>View query plan of a currently running SQL statement.</listitem>
        <listitem>View locks held by a process.</listitem>
        <listitem>View user table statistics.</listitem>
        <listitem>View user index statistics.</listitem>
      </itemizedlist>
    ''; 

    homepage = http://ptop.projects.postgresql.org/;
  };
}
