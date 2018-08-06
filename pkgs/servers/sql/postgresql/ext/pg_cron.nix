{ stdenv, fetchFromGitHub, postgresql }:

stdenv.mkDerivation rec {
  name = "pg_cron-${version}";
  version = "1.1.2";

  buildInputs = [ postgresql ];

  src = fetchFromGitHub {
    owner  = "citusdata";
    repo   = "pg_cron";
    rev    = "refs/tags/v${version}";
    sha256 = "0n74dx1wkg9qxvjhnx03028465ap3p97v2kzqww833dws1wqk5m1";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  passthru = {
    versionCheck = postgresql.compareVersion "9.5" >= 0;
  };

  meta = with stdenv.lib; {
    description = "Run Cron jobs through PostgreSQL";
    homepage    = https://www.citusdata.com/;
    maintainers = with maintainers; [ thoughtpolice ];
    platforms   = platforms.linux;
    license     = licenses.postgresql;
  };
}
