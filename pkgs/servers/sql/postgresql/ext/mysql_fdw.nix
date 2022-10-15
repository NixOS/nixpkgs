{ lib, stdenv, fetchFromGitHub, postgresql, libmysqlclient }:
stdenv.mkDerivation rec {
  pname = "mysql_fdw";
  version = "REL-2_8_0";

  src = fetchFromGitHub {
    owner  = "EnterpriseDB";
    repo   =  pname;
    rev    = "d9860baa463cd9f4878dcaccb96dd8432d5ea36f";
    sha256 = "sha256-P/D67rn2uNFjMt/eTyjZ1VWUCIwW6XHW5zMQkV/X6jo=";
  };

  buildPhase = "USE_PGXS=1 make";
  installPhase = ''
    install -D mysql_fdw.so -t $out/lib/
    install -D ./{mysql_fdw--1.0--1.1.sql,mysql_fdw--1.0.sql,mysql_fdw--1.1.sql,mysql_fdw.control} -t $out/share/postgresql/extension
  '';

  buildInputs = [ postgresql libmysqlclient ];

  meta = with lib; {
    description = "This PostgreSQL extension implements a Foreign Data Wrapper (FDW) for MySQL";
    homepage    = "https://github.com/EnterpriseDB/mysql_fdw";
    maintainers = [ maintainers.hanDerPeder ];
    platforms   = postgresql.meta.platforms;
    license     = licenses.postgresql;
  };
}
