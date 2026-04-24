{
  fetchFromGitHub,
  lib,
}:

rec {
  version = "15.17";
  src = fetchFromGitHub {
    owner = "postgres";
    repo = "postgres";
    tag = "REL_15_17";
    hash = "sha256-IxvCNJfTbbKT/2dFnNLk3fNUYDaRwHQeeAmvGc1w/OY=";
  };

  muslPatches = {
    dont-use-locale-a = {
      url = "https://git.alpinelinux.org/aports/plain/main/postgresql15/dont-use-locale-a-on-musl.patch?id=f424e934e6d076c4ae065ce45e734aa283eecb9c";
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
