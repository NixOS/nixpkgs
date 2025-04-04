{
  postgresql,
  postgresqlTestHook,
  stdenvNoCC,
}:

{
  finalPackage,
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
    failureHook = "postgresqlStop";
    postgresqlTestUserOptions = "LOGIN SUPERUSER";
    passAsFile = [ "sql" ];
    checkPhase = ''
      runHook preCheck
      psql -a -v ON_ERROR_STOP=1 -f "$sqlPath"
      runHook postCheck
    '';
    installPhase = "touch $out";
  }
  // extraArgs
)
