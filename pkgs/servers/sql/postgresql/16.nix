{
  fetchFromGitHub,
  lib,
}:

rec {
  version = "16.13";
  src = fetchFromGitHub {
    owner = "postgres";
    repo = "postgres";
    tag = "REL_16_13";
    hash = "sha256-Ue117xTq4RMQfq70mnXRBwqJ+IUigW27FvHY7I519ng=";
  };

  muslPatches = {
    dont-use-locale-a = {
      url = "https://git.alpinelinux.org/aports/plain/main/postgresql16/dont-use-locale-a-on-musl.patch?id=08a24be262339fd093e641860680944c3590238e";
      hash = "sha256-fk+y/SvyA4Tt8OIvDl7rje5dLs3Zw+Ln1oddyYzerOo=";
    };
  };

  meta = {
    homepage = "https://www.postgresql.org";
    description = "Powerful, open source object-relational database system";
    changelog = "https://www.postgresql.org/docs/release/${version}/";
    teams = [ lib.teams.postgres ];
  };
}
