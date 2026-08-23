{
  lib,
  stdenv,
}:

{
  name,
  src,
  version ? "unstable",
  meta ? { },
  passthru ? { },
  ...
}@args:

stdenv.mkDerivation (
  builtins.removeAttrs args [
    "name"
    "version"
    "meta"
    "passthru"
  ]
  // {
    pname = "godot-module-${name}";
    inherit version src;

    dontBuild = true;
    dontConfigure = true;

    installPhase = ''
      runHook preInstall
      mkdir -p "$out/share/godot/modules/${name}"
      cp -r . "$out/share/godot/modules/${name}/"
      runHook postInstall
    '';

    meta = {
      description = "Godot C++ module: ${name}";
      license = lib.licenses.mit;
    }
    // meta;

    passthru = {
      moduleName = name;
    }
    // passthru;
  }
)
