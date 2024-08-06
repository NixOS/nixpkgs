{ lib, fetchFromGitHub, buildPgrxExtension, postgresql, gitUpdater }:

buildPgrxExtension rec {
  inherit postgresql;

  pname = "pgx_ulid";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "pksunkara";
    repo = "pgx_ulid";
    rev = "29a037e7e2dd8b18e4bb5e5ec4f9a6fe270e84bc";
    hash = "sha256-zql7wtZQ+GDEpM0kld7vHCbWNHSpPKjYZgVWhx1GtvU=";
  };
  cargoHash = "sha256-kMo5wnQA8FakTEYebbpoKxMGi1SrFJQd45ZYHGUqVrY=";

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  # Tests try to write to the nix store.
  doCheck = false;

  meta = with lib; {
    description = "A PostgreSQL extension to support ULID";
    homepage = "https://github.com/pksunkara/pgx_ulid";
    maintainers = [ maintainers.renzo ];
    platforms = postgresql.meta.platforms;
    license = licenses.mit;
    broken = versionOlder postgresql.version "11";
  };
}
