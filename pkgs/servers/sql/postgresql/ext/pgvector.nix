{ lib, stdenv, fetchFromGitHub, postgresql }:

stdenv.mkDerivation rec {
  pname = "pgvector";
  version = "0.2.6";

  src = fetchFromGitHub {
    owner = "ankane";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-NmUI4pXwf6PHuLbkFy/hoA67j++A2Ju7zG/4og9U+qk=";
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
