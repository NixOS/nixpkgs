{
  R,
  fetchFromGitHub,
  lib,
  pkg-config,
  postgresql,
  postgresqlBuildExtension,
  stdenv,
}:

postgresqlBuildExtension rec {
  pname = "plr";
  version = "${builtins.replaceStrings [ "_" ] [ "." ] (lib.strings.removePrefix "REL" src.rev)}";

  src = fetchFromGitHub {
    owner = "postgres-plr";
    repo = "plr";
    tag = "REL8_4_7";
    hash = "sha256-PdvFEmtKfLT/xfaf6obomPR5hKC9F+wqpfi1heBphRk=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ R ];

  makeFlags = [ "USE_PGXS=1" ];

  meta = {
    description = "PL/R - R Procedural Language for PostgreSQL";
    homepage = "https://github.com/postgres-plr/plr";
    changelog = "https://github.com/postgres-plr/plr/blob/${src.rev}/changelog.md";
    maintainers = with lib.maintainers; [ qoelet ];
    platforms = postgresql.meta.platforms;
    license = lib.licenses.gpl2Only;
  };
}
