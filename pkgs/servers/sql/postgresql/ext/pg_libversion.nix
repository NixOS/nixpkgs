{
  lib,
  stdenv,
  fetchFromGitHub,
  gitUpdater,
  pkg-config,
  postgresql,
  libversion,
  buildPostgresqlExtension,
}:

buildPostgresqlExtension (finalAttrs: {
  pname = "pg_libversion";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "repology";
    repo = "postgresql-libversion";
    rev = finalAttrs.version;
    hash = "sha256-3nqXaBwPRUSo6wUY5YMjJ/nFFKmhgP1zFKapD+RqSDw=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libversion
  ];

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    description = "PostgreSQL extension with support for version string comparison";
    homepage = "https://github.com/repology/postgresql-libversion";
    license = licenses.mit;
    maintainers = [ maintainers.jopejoe1 ];
    platforms = postgresql.meta.platforms;
  };
})
