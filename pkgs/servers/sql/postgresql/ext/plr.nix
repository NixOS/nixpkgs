{
  buildEnv,
  fetchFromGitHub,
  lib,
  pkg-config,
  postgresql,
  postgresqlBuildExtension,
  postgresqlTestExtension,
  R,
  rPackages,
  stdenv,
}:

postgresqlBuildExtension (finalAttrs: {
  pname = "plr";
  version = "${builtins.replaceStrings [ "_" ] [ "." ] (
    lib.strings.removePrefix "REL" finalAttrs.src.rev
  )}";

  src = fetchFromGitHub {
    owner = "postgres-plr";
    repo = "plr";
    tag = "REL8_4_7";
    hash = "sha256-PdvFEmtKfLT/xfaf6obomPR5hKC9F+wqpfi1heBphRk=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ R ];

  makeFlags = [ "USE_PGXS=1" ];

  passthru = {
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
