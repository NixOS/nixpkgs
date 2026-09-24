{
  diffutils,
  lib,
  replaceVarsWith,
  runtimeShell,
  stdenv,
  # PostgreSQL package
  finalPackage,
  # PostgreSQL package's outputs
  outputs,
}:

replaceVarsWith {
  name = "pg_config";
  src = ./pg_config.sh;
  dir = "bin";
  isExecutable = true;
  replacements = {
    inherit runtimeShell;
    "pg_config.env" = replaceVarsWith {
      name = "pg_config.env";
      src = "${lib.getDev finalPackage}/nix-support/pg_config.env";
      replacements = outputs;
    };
  };
  nativeCheckInputs = [
    diffutils
  ];
  # The expected output only matches when outputs have *not* been altered by postgresql.withPackages.
  postCheck = lib.optionalString (outputs.out == lib.getOutput "out" finalPackage) ''
    if [ -e ${lib.getDev finalPackage}/nix-support/pg_config.expected ]; then
        diff ${lib.getDev finalPackage}/nix-support/pg_config.expected <($out/bin/pg_config)
    fi
  '';
}
