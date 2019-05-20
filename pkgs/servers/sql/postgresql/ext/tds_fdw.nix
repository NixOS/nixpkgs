{ stdenv, fetchFromGitHub, postgresql, freetds }:

stdenv.mkDerivation rec {
  pname = "tds_fdw";
  version = "1.0.8";

  buildInputs = [ postgresql freetds ];

  src = fetchFromGitHub {
    owner  = "tds-fdw";
    repo   =  pname;
    rev    = "refs/tags/v${version}";
    sha256 = "0dlv1imiy773yplqqpl26xka65bc566k2x81wkrbvwqagnwvcai2";
  };

  installPhase = ''
    install -D tds_fdw.so                  -t $out/lib
    install -D sql/tds_fdw--${version}.sql -t $out/share/extension
    install -D tds_fdw.control             -t $out/share/extension
  '';

  meta = with stdenv.lib; {
    description = "A PostgreSQL foreign data wrapper to connect to TDS databases (Sybase and Microsoft SQL Server)";
    homepage    = https://github.com/tds-fdw/tds_fdw;
    maintainers = [ maintainers.steve-chavez ];
    platforms   = postgresql.meta.platforms;
    license     = licenses.postgresql;
  };
}
