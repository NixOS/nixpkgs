{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  torch,
  torchWithCuda,
  torchWithRocm,
  torchvision,
  safetensors,
  einops,
  config,
  gpuBackend ? (
    if config.cudaSupport then
      "cuda"
    else if config.rocmSupport then
      "rocm"
    else
      "none"
  ),
}:
let
  myTorch =
    if gpuBackend == "cuda" then
      torchWithCuda
    else if gpuBackend == "rocm" then
      torchWithRocm
    else
      torch;
in
buildPythonPackage rec {
  pname = "spandrel";
  version = "0.4.1";
  pyproject = true;

  build-system = [ setuptools ];

  buildInputs = [
    myTorch
    torchvision
    safetensors
    einops
  ];

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ZG2YFqlC5Z1WqrLckENTlS5X3uSyyz9Z9+pNwPsRofI=";
  };

  pythonImportsCheck = [ "spandrel" ];

  meta = {
    description = "Library for loading and running pre-trained PyTorch models";
    homepage = "https://github.com/chaiNNer-org/spandrel/";
    changelog = "https://github.com/chaiNNer-org/spandrel/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ scd31 ];
  };
}
