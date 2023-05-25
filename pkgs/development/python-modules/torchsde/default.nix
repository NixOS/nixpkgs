{ lib
, buildPythonPackage
, fetchFromGitHub

# build-system
, setuptools

# dependencies
, boltons
, numpy
, scipy
, torch
, trampoline

# tests
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "torchsde";
  version = "0.2.4";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "google-research";
    repo = "torchsde";
    rev = "v${version}";
    hash = "sha256-qQ7oswm0qTdq1xpQElt5cd3K0zskH+H/lgyEnxbCqsI=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "numpy==1.19.*" "numpy" \
      --replace "scipy==1.5.*" "scipy"
  '';

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    boltons
    numpy
    scipy
    torch
    trampoline
  ];

  pythonImportsCheck = [ "torchsde" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

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
