{ lib, stdenv, fetchFromGitHub, postgresql }:

stdenv.mkDerivation rec {
  pname = "rum";
  version = "1.3.11";

  src = fetchFromGitHub {
    owner = "postgrespro";
    repo = "rum";
    rev = version;
    sha256 = "sha256-OuVyZ30loPycQkDwlL0289H/4RRPneibqgibgzqhWo4=";
  };

  buildInputs = [ postgresql ];

  makeFlags = [ "USE_PGXS=1" ];

  installPhase = ''
    install -D -t $out/lib *.so
    install -D -t $out/share/postgresql/extension *.control
    install -D -t $out/share/postgresql/extension *.sql
  '';

  meta = with lib; {
    description = "Full text search index method for PostgreSQL";
    homepage = "https://github.com/postgrespro/rum";
    license = licenses.postgresql;
    platforms = postgresql.meta.platforms;
    maintainers = with maintainers; [ DeeUnderscore ];
  };
}
