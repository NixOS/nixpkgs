{
  fetchFromGitHub,
  file,
  lib,
  postgresql,
  postgresqlBuildExtension,
  postgresqlTestExtension,
}:

postgresqlBuildExtension (finalAttrs: {
  pname = "pg_byteamagic";
  version = "0.2.4";

  src = fetchFromGitHub {
    owner = "nmandery";
    repo = "pg_byteamagic";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0RRElMMVUm3cXLI7G3SkIVr8yA/Rk3gBsgXG+EFU3CI=";
  };

  buildInputs = [
    file
  ];

  passthru.tests = {
    extension = postgresqlTestExtension {
      inherit (finalAttrs) finalPackage;
      sql = ''
        CREATE EXTENSION byteamagic;
        SELECT byteamagic_mime('test');
      '';
      asserts = [
        {
          query = "SELECT byteamagic_mime('test')";
          expected = "'text/plain'";
          description = "`byteamagic_mime(...) should return proper mimetype.";
        }
      ];
    };
  };

  meta = {
    description = "PostgreSQL extension to determinate the filetypes of bytea BLOBs";
    homepage = "https://github.com/nmandery/pg_byteamagic";
    changelog = "https://raw.githubusercontent.com/nmandery/pg_byteamagic/refs/tags/v${finalAttrs.version}/Changes";
    license = lib.licenses.bsd2WithViews;
    teams = [ lib.teams.apm ];
    platforms = postgresql.meta.platforms;
  };
})
