{
  lib,
  linkFarm,
  clr,
  ollama,
  python3Packages,
  rocmPackages,
  magma-hip,
  emptyDirectory,
  stdenv,
}:
# This package exists purely to have a bunch of passthru.tests attrs
let
  availableRocmDrvs = lib.pipe rocmPackages [
    (lib.mapAttrsToList (
      name: value: {
        inherit name;
        evaluated = builtins.tryEval value;
      }
    ))
    (builtins.filter (x: x.evaluated.success))
    (map (x: {
      inherit (x) name;
      value = x.evaluated.value;
    }))
    (builtins.filter (x: lib.isDerivation x.value && (x.value.meta.available or true)))
  ];
in
stdenv.mkDerivation {
  name = "rocm-tests";
  nativeBuildInputs = [
    clr
  ];
  src = emptyDirectory;
  postInstall = "mkdir -p $out";
  passthru.tests = {
    ollama = ollama.override {
      inherit rocmPackages;
      acceleration = "rocm";
    };
    rocmPackagesDerivations = linkFarm "rocmPackagesDerivations" (
      map (x: {
        name = x.name;
        path = x.value;
      }) availableRocmDrvs
    );
    torch = python3Packages.torch.override {
      inherit rocmPackages;
      rocmSupport = true;
      cudaSupport = false;
      magma-hip = magma-hip.override {
        inherit rocmPackages;
      };
    };
  };
}
