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
    passAsFile = [ "sql" ];
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
      psql -a -v ON_ERROR_STOP=1 -f "$sqlPath"
      runHook postCheck
    '';
    installPhase = "touch $out";
  }
  // lib.removeAttrs extraArgs [
    "asserts"
    "finalPackage"
    "sql"
    "withPackages"
  ]
)
