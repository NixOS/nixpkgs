{ lib, stdenv, fetchFromGitHub, libkrb5, openssl, postgresql }:

stdenv.mkDerivation rec {
  pname = "pgaudit";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "pgaudit";
    repo = "pgaudit";
    rev = version;
    hash = "sha256-8pShPr4HJaJQPjW1iPJIpj3CutTx8Tgr+rOqoXtgCcw=";
  };

  buildInputs = [ libkrb5 openssl postgresql ];

  makeFlags = [ "USE_PGXS=1" ];

  installPhase = ''
    install -D -t $out/lib *.so
    install -D -t $out/share/postgresql/extension *.sql
    install -D -t $out/share/postgresql/extension *.control
  '';

  meta = with lib; {
    description = "Open Source PostgreSQL Audit Logging";
    homepage = "https://github.com/pgaudit/pgaudit";
    maintainers = with maintainers; [ idontgetoutmuch ];
    platforms = postgresql.meta.platforms;
    license = licenses.postgresql;
  };
}
