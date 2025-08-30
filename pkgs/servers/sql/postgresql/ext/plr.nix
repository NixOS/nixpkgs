{
  buildEnv,
  fetchFromGitHub,
  lib,
  nix-update-script,
  pkg-config,
  postgresql,
  postgresqlBuildExtension,
  postgresqlTestExtension,
  R,
  rPackages,
}:

postgresqlBuildExtension (finalAttrs: {
  pname = "plr";
  version = "8.4.8";

  src = fetchFromGitHub {
    owner = "postgres-plr";
    repo = "plr";
    tag = "REL${lib.replaceString "." "_" finalAttrs.version}";
    hash = "sha256-FLL61HsZ6WaWBP9NqrJjhMFSVyVBIpVO0wv+kXMuAaU=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ R ];

  makeFlags = [ "USE_PGXS=1" ];

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [ "--version-regex=^REL(\\d+)_(\\d+)_(\\d+)$" ];
    };
    withPackages =
      f:
      let
        pkgs = f rPackages;
        paths = lib.concatMapStringsSep ":" (pkg: "${pkg}/library") pkgs;
      in
      buildEnv {
        name = "${finalAttrs.pname}-with-packages-${finalAttrs.version}";
        paths = [ finalAttrs.finalPackage ];
        passthru.wrapperArgs = [
          ''--set R_LIBS_SITE "${paths}"''
        ];
      };
    tests.extension = postgresqlTestExtension {
      finalPackage = finalAttrs.finalPackage.withPackages (ps: [ ps.base64enc ]);
      sql = ''
        CREATE EXTENSION plr;
        DO LANGUAGE plr $$
          require('base64enc')
          base64encode(1:100)
        $$;
      '';
    };
  };

  meta = {
    description = "PL/R - R Procedural Language for PostgreSQL";
    homepage = "https://github.com/postgres-plr/plr";
    changelog = "https://github.com/postgres-plr/plr/blob/${finalAttrs.src.rev}/changelog.md";
    maintainers = with lib.maintainers; [ qoelet ];
    platforms = postgresql.meta.platforms;
    license = lib.licenses.gpl2Only;
  };
})
