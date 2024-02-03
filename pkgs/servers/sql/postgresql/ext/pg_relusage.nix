{ lib, stdenv, fetchFromGitHub, postgresql }:

stdenv.mkDerivation rec {
  pname = "pg_relusage";
  version = "0.0.1";

  buildInputs = [ postgresql ];

  src = fetchFromGitHub {
    owner  = "adept";
    repo   = pname;
    rev    = "refs/tags/${version}";
    sha256 = "8hJNjQ9MaBk3J9a73l+yQMwMW/F2N8vr5PO2o+5GvYs=";
  };

  installPhase = ''
    install -D -t $out/lib *${postgresql.dlSuffix}
    install -D -t $out/share/postgresql/extension *.sql
    install -D -t $out/share/postgresql/extension *.control
  '';

  meta = with lib; {
    description = "pg_relusage extension for PostgreSQL: discover and log the relations used in your statements";
    homepage    = "https://github.com/adept/pg_relusage";
    maintainers = with maintainers; [ thenonameguy ];
    platforms   = postgresql.meta.platforms;
    license     = licenses.postgresql;
  };
}
