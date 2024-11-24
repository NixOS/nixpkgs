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
  version = "0.0.23";
  pyproject = true;
  build-system = [ setuptools ];

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "maxrmorrison";
    repo = "torchcrepe";
    # No releases: https://github.com/maxrmorrison/torchcrepe/commit/e2c305878ec7a89aec85a01f8d223a75a36d30b6
    rev = "e2c305878ec7a89aec85a01f8d223a75a36d30b6";
    hash = "sha256-fhBU5KFDNDG4g4KNivE/dRpMPyu1QNa9xKN6HIz3tK4=";
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
