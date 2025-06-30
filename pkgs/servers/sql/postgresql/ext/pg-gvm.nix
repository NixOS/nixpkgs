{
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
  postgresqlBuildExtension,
}:

postgresqlBuildExtension (finalAttrs: {
  pname = "pg-gvm";
  version = "22.6.9";

  src = fetchFromGitHub {
    owner = "greenbone";
    repo = "pg-gvm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-T1U7t6ORHtmWeg77PR4gUH4nn3ywVC3MnvqoEIpJ4aw=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
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
    platforms = postgresql.meta.platforms;
  };
})
