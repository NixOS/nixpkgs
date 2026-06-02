{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  cmake,
  ninja,
  numpy,
  scikit-build-core,

  # buildInputs
  blas,
}:

buildPythonPackage (finalAttrs: {
  pname = "sparsediffpy";
  version = "0.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "SparseDifferentiation";
    repo = "SparseDiffPy";
    tag = "v${finalAttrs.version}";
    # SparseDiffEngine is built from source and their cmake does not support finding it on the
    # system. We fallback to using the git submodule approach for now.
    fetchSubmodules = true;
    hash = "sha256-4FiObnGIJSSH7BMkKS7y7rc4HYzDgMV7ym+wPZ/KHJ8=";
  };

  build-system = [
    cmake
    ninja
    numpy
    scikit-build-core
  ];
  dontUseCmakeConfigure = true;

  buildInputs = [
    blas
  ];

  dependencies = [
    numpy
  ];

  pythonImportsCheck = [ "sparsediffpy" ];

  # No tests
  doCheck = false;

  meta = {
    description = "Python bindings for SparseDiffEngine, a C library for computing sparse Jacobians and Hessians";
    homepage = "https://github.com/SparseDifferentiation/SparseDiffPy";
    changelog = "https://github.com/SparseDifferentiation/SparseDiffPy/blob/${finalAttrs.src.tag}/RELEASES.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
