{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
<<<<<<< HEAD
=======
  pythonOlder,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

buildPythonPackage rec {
  pname = "spython";
<<<<<<< HEAD
  version = "0.3.15";
  pyproject = true;

=======
  version = "0.3.14";
  pyproject = true;

  disabled = pythonOlder "3.9";

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  src = fetchFromGitHub {
    owner = "singularityhub";
    repo = "singularity-cli";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-XYiudDXXiX0izFZZpQb71DBg/wRKjeupvKHixGFVuKM=";
=======
    hash = "sha256-PNMzqnKb691wcd8aGSleqHOcsUrahl8e0r5s5ek5GmQ=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail '"pytest-runner"' ""
  '';

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "spython" ];

  disabledTests = [
    # Assertion errors
    "test_has_no_instances"
    "test_check_install"
    "test_check_get_singularity_version"
  ];

  disabledTestPaths = [
    # Tests are looking for something that doesn't exist
    "spython/tests/test_client.py"
  ];

<<<<<<< HEAD
  meta = {
    description = "Streamlined singularity python client (spython) for singularity";
    homepage = "https://github.com/singularityhub/singularity-cli";
    changelog = "https://github.com/singularityhub/singularity-cli/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "Streamlined singularity python client (spython) for singularity";
    homepage = "https://github.com/singularityhub/singularity-cli";
    changelog = "https://github.com/singularityhub/singularity-cli/blob/${version}/CHANGELOG.md";
    license = licenses.mpl20;
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "spython";
  };
}
