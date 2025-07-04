{
  clr,
  ollama,
  python3Packages,
  rocmPackages,
  magma-hip,
  emptyDirectory,
  stdenv,
}:
# This package exists purely to have a bunch of passthru.tests attrs
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
