{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  numpy,
  pytest,
}:

buildPythonPackage rec {
  pname = "triton-kernels";
  version = "3.5.0"; # Triton monorepo tag
  pyproject = true;

  # Pinned to Triton v3.5.0 as required by vLLM v0.11.1rc3
  # See: https://github.com/vllm-project/vllm/blob/v0.11.1rc3/requirements/cuda.txt#L17
  src = fetchFromGitHub {
    owner = "triton-lang";
    repo = "triton";
    tag = "v3.5.0";
    hash = "sha256-F6T0n37Lbs+B7UHNYzoIQHjNNv3TcMtoXjNrT8ZUlxY=";
  };

  # Extract only the triton_kernels subdirectory
  sourceRoot = "${src.name}/python/triton_kernels";

  build-system = [ setuptools ];

  dependencies = [
    numpy
    pytest # Listed as runtime dependency in upstream pyproject.toml
  ];

  pythonImportsCheck = [ "triton_kernels" ];

  meta = {
    description = "Triton Kernels - Pre-written kernels for common operations";
    homepage = "https://github.com/triton-lang/triton";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ daniel-fahey ];
    platforms = lib.platforms.linux;
  };
}
