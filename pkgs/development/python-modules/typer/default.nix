{
  lib,
  mkPythonMetaPackage,
  typer-slim,
}:

mkPythonMetaPackage {
  pname = "typer";
  inherit (typer-slim) version optional-dependencies;
  dependencies = [ typer-slim ] ++ typer-slim.optional-dependencies.standard;
  meta = {
    inherit (typer-slim.meta)
      changelog
      description
      homepage
      license
      maintainers
      ;
  };
}
