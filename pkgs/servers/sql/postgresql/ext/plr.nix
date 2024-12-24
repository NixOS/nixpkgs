{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  R,
  postgresql,
  buildPostgresqlExtension,
}:

buildPostgresqlExtension rec {
  pname = "plr";
  version = "${builtins.replaceStrings [ "_" ] [ "." ] (lib.strings.removePrefix "REL" src.rev)}";

  src = fetchFromGitHub {
    owner = "postgres-plr";
    repo = "plr";
    rev = "REL8_4_7";
    sha256 = "sha256-PdvFEmtKfLT/xfaf6obomPR5hKC9F+wqpfi1heBphRk=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ R ];

  makeFlags = [ "USE_PGXS=1" ];

  meta = with lib; {
    description = "PL/R - R Procedural Language for PostgreSQL";
    homepage = "https://github.com/postgres-plr/plr";
    changelog = "https://github.com/postgres-plr/plr/blob/${src.rev}/changelog.md";
    maintainers = with maintainers; [ qoelet ];
    platforms = postgresql.meta.platforms;
    license = licenses.gpl2Only;
  };
}
