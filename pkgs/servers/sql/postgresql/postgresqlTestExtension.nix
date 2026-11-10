{
  lib,
  postgresql,
  postgresqlTestHook,
  stdenvNoCC,
}:

{
  asserts ? [ ],
  finalPackage,
  sql,
  withPackages ? [ ],
  ...
}@extraArgs:
stdenvNoCC.mkDerivation (
  {
    name = "${finalPackage.name}-test-extension";
    dontUnpack = true;
    doCheck = true;
    nativeCheckInputs = [
      postgresqlTestHook
      (postgresql.withPackages (ps: [ finalPackage ] ++ (map (p: ps."${p}") withPackages)))
    ];
    postgresqlTestUserOptions = "LOGIN SUPERUSER";
    sql =
      sql
      + lib.concatMapStrings (
        {
          query,
          expected,
          description,
        }:
        ''
          DO $$ BEGIN
            ASSERT (${query}) = (${expected}), '${lib.replaceStrings [ "'" ] [ "''" ] description}';
          END $$;
        ''
      ) asserts;
    checkPhase = ''
      runHook preCheck
      sqlPath=$TMPDIR/test.sql
      printf "%s" "$sql" > $sqlPath
      psql -a -v ON_ERROR_STOP=1 -f "$sqlPath"
      runHook postCheck
    '';
    installPhase = "touch $out";
    __structuredAttrs = true;
  }
  // lib.removeAttrs extraArgs [
    "asserts"
    "finalPackage"
    "sql"
    "withPackages"
  ]
)
