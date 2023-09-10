{ lib, stdenv, fetchFromGitHub, postgresql }:

stdenv.mkDerivation rec {
  pname = "pgsql-http";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "pramsey";
    repo = pname;
    rev = "v${version}";
    sha256 = "1jl6rpys24qxhkv3q798pp9v03z2z7gswivp19yria9xr3bg6wjv";
  };

  buildInputs = [ postgresql curl.dev ];

  installPhase = ''
    install -D -t $out/lib http.so
    install -D -t $out/share/postgresql/extension sql/http-*.sql
    install -D -t $out/share/postgresql/extension http.control
  '';

  meta = with lib; {
    description = "HTTP client for PostgreSQL, retrieve a web page from inside the database.";
    homepage = "https://github.com/pramsey/pgsql-http";
    changelog = "https://github.com/pramsey/pgsql-http/releases/tag/v${version}";
    license = licenses.postgresql;
    platforms = postgresql.meta.platforms;
  };
}
