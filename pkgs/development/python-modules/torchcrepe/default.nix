{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  librosa,
  pytestCheckHook,
  pythonOlder,
  resampy,
  scipy,
  setuptools,
  torch,
  torchaudio,
  tqdm,
}:

buildPythonPackage {
  pname = "torchcrepe";
  version = "0.0.24";
  pyproject = true;
  build-system = [ setuptools ];

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "maxrmorrison";
    repo = "torchcrepe";
    # No releases: https://github.com/maxrmorrison/torchcrepe/commit/19e2ec3d494c0797a5ff2a11408ec5838fba6681
    rev = "19e2ec3d494c0797a5ff2a11408ec5838fba6681";
    hash = "sha256-w2T8D3ATCHVBCBhMdLSYdV0yb9vUYwZLz+B2X2gteEU=";
  };

  dependencies = [
    librosa
    resampy
    scipy
    torch
    torchaudio
    tqdm
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "torchcrepe" ];

  meta = {
    description = "Pytorch implementation of the CREPE pitch tracker";
    homepage = "https://github.com/maxrmorrison/torchcrepe";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ derdennisop ];
  };
}
