{ lib, stdenv, fetchFromGitHub, curl, postgresql }:

stdenv.mkDerivation rec {
  pname = "pgsql-http";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "pramsey";
    repo = "pgsql-http";
    rev = "v${version}";
    hash = "sha256-CPHfx7vhWfxkXsoKTzyFuTt47BPMvzi/pi1leGcuD60=";
  };

  buildInputs = [ curl postgresql ];

  installPhase = ''
    install -D -t $out/lib *${postgresql.dlSuffix}
    install -D -t $out/share/postgresql/extension *.sql
    install -D -t $out/share/postgresql/extension *.control
  '';

  meta = with lib; {
    description = "HTTP client for PostgreSQL, retrieve a web page from inside the database";
    homepage = "https://github.com/pramsey/pgsql-http";
    changelog = "https://github.com/pramsey/pgsql-http/releases/tag/v${version}";
    maintainers = [ ];
    platforms = postgresql.meta.platforms;
    license = licenses.mit;
  };
}
