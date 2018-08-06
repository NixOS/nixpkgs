{ stdenv, fetchFromGitHub, postgresql, protobufc }:

stdenv.mkDerivation rec {
  name = "pg_topn-${version}";
  version = "2.1.0";

  nativeBuildInputs = [ protobufc ];
  buildInputs = [ postgresql ];

  src = fetchFromGitHub {
    owner  = "citusdata";
    repo   = "postgresql-topn";
    rev    = "refs/tags/v${version}";
    sha256 = "00hc3hgnqv9xaalizbcvprb7s55sydj2qgk3rhgrdlwg2g025h62";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  passthru = {
    versionCheck = postgresql.compareVersion "9.4" >= 0;
  };

  meta = with stdenv.lib; {
    description = "Efficient querying of 'top values' for PostgreSQL";
    homepage    = https://www.citusdata.com/;
    maintainers = with maintainers; [ thoughtpolice ];
    platforms   = platforms.linux;
    license     = licenses.agpl3;
  };
}
