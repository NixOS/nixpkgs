{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  boltons,
  numpy,
  scipy,
  torch,
  trampoline,

  # tests
  pytest7CheckHook,
}:

buildPythonPackage rec {
  pname = "torchsde";
  version = "0.2.6";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "google-research";
    repo = "torchsde";
    rev = "refs/tags/v${version}";
    hash = "sha256-D0p2tL/VvkouXrXfRhMuCq8wMtzeoBTppWEG5vM1qCo=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "numpy==1.19.*" "numpy" \
      --replace "scipy==1.5.*" "scipy"
  '';

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    boltons
    numpy
    scipy
    torch
    trampoline
  ];

  pythonImportsCheck = [ "torchsde" ];

  nativeCheckInputs = [ pytest7CheckHook ];

  disabledTests = [
    # RuntimeError: a view of a leaf Variable that requires grad is being used in an in-place operation.
    "test_adjoint"
  ];

  meta = with lib; {
    changelog = "https://github.com/google-research/torchsde/releases/tag/v${version}";
    description = "Differentiable SDE solvers with GPU support and efficient sensitivity analysis";
    homepage = "https://github.com/google-research/torchsde";
    license = licenses.asl20;
    maintainers = teams.tts.members;
  };
}
