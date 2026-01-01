{
  lib,
<<<<<<< HEAD
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  numpy,
  scipy,
  spglib,

  # tests
=======
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  numpy,
  scipy,
  spglib,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "symfc";
<<<<<<< HEAD
  version = "1.6.0";
=======
  version = "1.5.4";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "symfc";
    repo = "symfc";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-YDVO1/vt30ZaBOTCaYBtr3fkcuJmPa8Eg72k3XWpacg=";
=======
    hash = "sha256-SGFKbOVi5cVw+8trXrSnO0v2obpJBZrj+7yXk7hK+1s=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    numpy
    scipy
    spglib
  ];

<<<<<<< HEAD
  pythonImportsCheck = [ "symfc" ];
=======
  pythonImportsCheck = [
    "symfc"
  ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  nativeCheckInputs = [
    pytestCheckHook
  ];

<<<<<<< HEAD
  disabledTests = lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64) [
    # assert (np.float64(0.5555555555555556) == 1.0 ± 1.0e-06
    "test_fc_basis_set_o3"
  ];

=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  meta = {
    description = "Generate symmetrized force constants";
    homepage = "https://github.com/symfc/symfc";
    changelog = "https://github.com/symfc/symfc/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
