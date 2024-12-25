{
  lib,
  stdenv,
  fetchFromGitLab,
  postgresql,
  buildPostgresqlExtension,
}:

buildPostgresqlExtension rec {
  pname = "pg_ed25519";
  version = "0.2";
  src = fetchFromGitLab {
    owner = "dwagin";
    repo = "pg_ed25519";
    rev = version;
    sha256 = "16w3qx3wj81bzfhydl2pjhn8b1jak6h7ja9wq1kc626g0siggqi0";
  };

  meta = with lib; {
    description = "PostgreSQL extension for signing and verifying ed25519 signatures";
    homepage = "https://gitlab.com/dwagin/pg_ed25519";
    maintainers = [ maintainers.renzo ];
    platforms = postgresql.meta.platforms;
    license = licenses.mit;
    # Broken on darwin and linux (JIT) with no upstream fix available.
    broken = lib.versionAtLeast postgresql.version "16" && stdenv.cc.isClang;
  };
}
