{ stdenv, fetchFromGitHub
, withMySQL ? true, withPSQL ? false, withSQLite ? false
, mysql, postgresql, sqlite, gawk
, lib
}:

stdenv.mkDerivation rec {
  name = "shmig-${version}";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "mbucc";
    repo = "shmig";
    rev = "v${version}";
    sha256 = "15ry1d51d6dlzzzhck2x57wrq48vs4n9pp20bv2sz6nk92fva5l5";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  postPatch = ''
    patchShebangs .

    substituteInPlace shmig \
      --replace "\`which mysql\`" "${lib.optionalString withMySQL "${mysql.client}/bin/mysql"}" \
      --replace "\`which psql\`" "${lib.optionalString withPSQL "${postgresql}/bin/psql"}" \
      --replace "\`which sqlite3\`" "${lib.optionalString withSQLite "${sqlite}/bin/sqlite3"}" \
      --replace "awk" "${gawk}/bin/awk"
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
