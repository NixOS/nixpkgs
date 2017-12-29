{ stdenv, fetchFromGitHub
, withMySQL ? false, withPSQL ? false, withSQLite ? false
, mariadb, postgresql, sqlite, gawk, which
, lib
}:

stdenv.mkDerivation {
  name = "shmig-2017-07-24";

  src = fetchFromGitHub {
    owner = "mbucc";
    repo = "shmig";
    rev = "aff54e03d13f8f95b422cf898505490a56152a4a";
    sha256 = "08q94dka5yqkzkis3w7j1q8kc7d3kk7mb2drx8ms59jcqvp847j3";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  postPatch = ''
    patchShebangs .

    substituteInPlace shmig \
      --replace "\`which mysql\`" "${lib.optionalString withMySQL "${mariadb}/bin/mysql"}" \
      --replace "\`which psql\`" "${lib.optionalString withPSQL "${postgresql}/bin/psql"}" \
      --replace "\`which sqlite3\`" "${lib.optionalString withSQLite "${sqlite}/bin/sqlite3"}" \
      --replace "awk" "${gawk}/bin/awk" \
      --replace "which" "${which}/bin/which"
  '';

  preBuild = ''
    mkdir -p $out/bin
  '';

  meta = with stdenv.lib; {
    description = "Minimalistic database migration tool with MySQL, PostgreSQL and SQLite support";
    homepage = "https://github.com/mbucc/shmig";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ma27 ];
  };
}
