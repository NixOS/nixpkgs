{ lib, stdenv, fetchFromGitHub, fetchpatch, postgresql }:

stdenv.mkDerivation rec {
  pname = "pgvector";
  version = "0.2.7";

  src = fetchFromGitHub {
    owner = "pgvector";
    repo = "pgvector";
    rev = "v${version}";
    sha256 = "sha256-kIgdr3+KC11Qxk1uBTmcN4dDaLIhfo/Fs898boESsBc=";
  };

  patches = [
    # Added support for Postgres 15. Remove with the next release.
    (fetchpatch {
      url = "https://github.com/pgvector/pgvector/commit/c9c6b96eede7d78758ca7ca5db98bf8b24021d0f.patch";
      sha256 = "sha256-hgCpGtuYmqo4Ttlpn4FBskbNdZmM1wJeMQBJZ7H923g=";
    })
  ];

  buildInputs = [ postgresql ];

  installPhase = ''
    install -D -t $out/lib vector.so
    install -D -t $out/share/postgresql/extension sql/vector-*.sql
    install -D -t $out/share/postgresql/extension vector.control
  '';

  meta = with lib; {
    description = "Open-source vector similarity search for PostgreSQL";
    homepage = "https://github.com/pgvector/pgvector";
    changelog = "https://github.com/pgvector/pgvector/raw/v${version}/CHANGELOG.md";
    license = licenses.postgresql;
    platforms = postgresql.meta.platforms;
    maintainers = [ maintainers.marsam ];
  };
}
