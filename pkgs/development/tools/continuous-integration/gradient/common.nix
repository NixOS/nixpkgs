{
  lib,
  nixVersions,
  fetchFromGitHub,
}:
let
  version = "1.0.0";
  srcHash = "sha256-mK8lxtf9yWu1CYC1O+7sYLa6BJwy0j5XsoNrs9Yl2Og=";
  pnpmDepsHash = "sha256-XSERnCs8/W6HBuTS5SurCX2uzqPrniKdaF7dpP6XrrI=";
  serverCargoHash = "sha256-VQkkYwKTBNuIQrpDtiDaWXWcjYT8gknmVHtUJH3H1uM=";
  cliCargoHash = "sha256-rtGU7udM46sDl/LG0AAo0Nw4x9OiaWlx5SGoGR52RAs=";
in
{
  inherit
    version
    pnpmDepsHash
    serverCargoHash
    cliCargoHash
    ;

  nixLatest = nixVersions.latest;

  src = fetchFromGitHub {
    owner = "wavelens";
    repo = "gradient";
    tag = "v${version}";
    hash = srcHash;
  };

  meta = {
    homepage = "https://github.com/wavelens/gradient";
    changelog = "https://github.com/wavelens/gradient/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.agpl3Only;
    teams = [ lib.teams.gradient ];
  };
}
