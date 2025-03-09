{
  clr,
  ollama,
  python3Packages,
  rocmPackages,
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
  postInstall = ''
    mkdir $out
    touch $out/empty
  '';
  passthru.tests = {
    ollama = ollama.override {
      inherit rocmPackages;
      acceleration = "rocm";
    };
    torch = python3Packages.torch.override {
      inherit rocmPackages;
      rocmSupport = true;
      cudaSupport = false;
    };
  };
}
