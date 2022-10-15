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

  buildInputs = [ postgresql libmysqlclient ];

  makeFlags = [ "USE_PGXS=1" ];

  installPhase = ''
    install -D -t $out/lib *.so
    install -D -t $out/share/postgresql/extension *.control
    install -D -t $out/share/postgresql/extension *.sql
  '';

  postFixup = ''
    patchelf --add-rpath ${libmysqlclient}/lib/mysql $out/lib/mysql_fdw.so
  '';

  meta = with lib; {
    description = "MySQL Foreign Data Wrapper for PostgreSQL";
    homepage    = "https://github.com/EnterpriseDB/mysql_fdw";
    maintainers = with maintainers; [ hanDerPeder ];
    platforms   = postgresql.meta.platforms;
    license     = licenses.postgresql;
  };
}
