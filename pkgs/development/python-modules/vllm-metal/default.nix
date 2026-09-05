{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  rustPlatform,
  python,

  # nativeBuildInputs
  clang,
  metal-toolchain,
  writableTmpDirAsHomeHook,

  # buildInputs
  apple-sdk,
  libiconv,

  # dependencies
  accelerate,
  apache-tvm-ffi,
  fastapi,
  llguidance,
  mlx,
  mlx-lm,
  mlx-vlm,
  nanobind,
  numpy,
  psutil,
  safetensors,
  starlette,
  transformers,
}:

buildPythonPackage (finalAttrs: {
  pname = "vllm-metal";
  version = "0.3.0-unstable-2026-08-24";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "vllm-project";
    repo = "vllm-metal";
    rev = "v0.3.0.dev20260824120553";
    hash = "sha256-EYllRUMFw3uTGsfOl9G8yB/lLSFBrwW6OgjldIA+NuI=";
  };

  cargoRoot = ".";
  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
  };

  # Upstream has no Cargo.lock — copy our generated one into the source tree
  postUnpack = ''
    cp ${./Cargo.lock} $sourceRoot/Cargo.lock
  '';

  postPatch = ''
    # Replace xcrun metal with Nix-store metal binary
    substituteInPlace vllm_metal/metal/build.py \
      --replace-fail '"xcrun", "-sdk", "macosx", "metal"' '"${metal-toolchain}/usr/bin/metal"'
    # Replace hardcoded clang++ with Nix-store clang
    substituteInPlace vllm_metal/metal/build.py \
      --replace-fail '"clang++"' '"${lib.getExe' stdenv.cc "c++"}"'
  '';

  preBuild = ''
    # Build the C++ extension and Metal shader libraries before maturin bundles them
    ${python.interpreter} -m vllm_metal.metal.build
  '';

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    clang
    metal-toolchain
    writableTmpDirAsHomeHook
  ];

  buildInputs = [
    mlx
    apple-sdk
    nanobind
    libiconv
  ];

  dependencies = [
    accelerate
    apache-tvm-ffi
    fastapi
    llguidance
    mlx
    mlx-lm
    mlx-vlm
    numpy
    psutil
    safetensors
    starlette
    transformers
  ];

  pythonRelaxDeps = [
    "mlx"
    "mlx-vlm"
    "transformers"
    "fastapi"
    "apache-tvm-ffi"
    "llguidance"
    "nanobind"
  ];

  # Tests require a GPU and vLLM 0.26.0 (not yet available in nixpkgs)
  doCheck = false;

  passthru.updateScript = ./update.sh;

  meta = {
    description = "vLLM hardware plugin for Apple Silicon";
    homepage = "https://github.com/vllm-project/vllm-metal";
    license = lib.licenses.asl20;
    platforms = [ "aarch64-darwin" ];
    maintainers = [ lib.maintainers.maxbrunet ];
  };
})
