{ lib, stdenv, fetchFromGitHub, postgresql }:

stdenv.mkDerivation rec {
  pname = "pgvector";
  version = "0.1.6";

  src = fetchFromGitHub {
    owner = "ankane";
    repo = pname;
    rev = "v${version}";
    sha256 = "108qf5pvqhz4vh31sijikajf4hrrk7rknrqzwj999psr33acag4z";
  };

  buildInputs = [ postgresql ];

  installPhase = ''
    install -D -t $out/lib vector.so
    install -D -t $out/share/postgresql/extension sql/vector-*.sql
    install -D -t $out/share/postgresql/extension vector.control
  '';

  meta = with lib; {
    description = "Open-source vector similarity search for PostgreSQL";
    homepage = "https://github.com/ankane/pgvector";
    changelog = "https://github.com/ankane/pgvector/raw/v${version}/CHANGELOG.md";
    license = licenses.postgresql;
    platforms = postgresql.meta.platforms;
    maintainers = [ maintainers.marsam ];
  };
}
