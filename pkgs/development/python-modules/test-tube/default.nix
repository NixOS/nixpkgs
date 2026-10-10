{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  future,
  imageio,
  numpy,
  pandas,
  torch,
  tensorboard,
}:

buildPythonPackage rec {
  pname = "test-tube";
  version = "0.628";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "williamFalcon";
    repo = "test-tube";
    rev = version;
    hash = "sha256-VdgOdlCIU0Bn5zratx4Zv03v5DpeCwAIewZwVrPqwHA=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  propagatedBuildInputs = [
    future
    imageio
    numpy
    pandas
    torch
    tensorboard
  ];

  meta = {
    homepage = "https://github.com/williamFalcon/test-tube";
    description = "Framework-agnostic library to track and parallelize hyperparameter search in machine learning experiments";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
