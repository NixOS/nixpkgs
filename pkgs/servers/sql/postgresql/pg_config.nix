{
  diffutils,
  lib,
  replaceVarsWith,
  runtimeShell,
  stdenv,
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
  nativeCheckInputs = [
    diffutils
  ];
  postCheck = ''
    if [ -e ${lib.getDev finalPackage}/nix-support/pg_config.expected ]; then
        diff ${lib.getDev finalPackage}/nix-support/pg_config.expected <($out/bin/pg_config)
    fi
  '';
}
