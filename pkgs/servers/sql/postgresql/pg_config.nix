{
  lib,
  replaceVarsWith,
  runtimeShell,
  # PostgreSQL package
  finalPackage,
}:

replaceVarsWith {
  name = "pg_config";
  src = ./pg_config.sh;
  dir = "bin";
  isExecutable = true;
  replacements = {
    inherit runtimeShell;
    postgresql-dev = lib.getDev finalPackage;
  };
}
