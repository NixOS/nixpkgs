{ lib, fetchFromGitHub, buildPgrxExtension, postgresql, gitUpdater }:

buildPgrxExtension rec {
  inherit postgresql;

  pname = "pgx_ulid";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "pksunkara";
    repo = "pgx_ulid";
    # rev: This is one commit past v0.1.4. It adds the Cargo.lock file.
    rev = "566bc1b21fa88276d7d7c27dd3cd4b74458dbc10";
    hash = "sha256-o6BnoaXIg4zbg86fTTcgydrl1JeykZxwDcvWz8+h31g=";
  };
  cargoHash = "sha256-nUI+QXhNgcmqRU/dY3Sk8bwdndJE8TT00LEFoauZ97s=";

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
