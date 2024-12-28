{
  buildPostgresqlExtension,
  cmake,
  fetchFromGitHub,
  glib,
  gvm-libs,
  icu,
  lib,
  libical,
  pcre2,
  pkg-config,
  postgresql,
}:

buildPostgresqlExtension (finalAttrs: {
  pname = "pg-gvm";
  version = "22.6.6";

  src = fetchFromGitHub {
    owner = "greenbone";
    repo = "pg-gvm";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-4620xHKh6dB3eIoBVZDf+qxLxmCCfFvdNDN/KnegWWA=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
    postgresql
  ];

  buildInputs = [
    glib
    gvm-libs
    icu
    libical
    pcre2
  ];

  meta = {
    description = "Greenbone Library for helper functions in PostgreSQL";
    homepage = "https://github.com/greenbone/pg-gvm";
    changelog = "https://github.com/greenbone/pg-gvm/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ tochiaha ];
    mainProgram = "pg-gvm";
    platforms = postgresql.meta.platforms;
  };
})
