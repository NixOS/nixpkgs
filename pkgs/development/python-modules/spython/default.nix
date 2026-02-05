{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "spython";
  version = "0.3.15";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "singularityhub";
    repo = "singularity-cli";
    tag = version;
    hash = "sha256-XYiudDXXiX0izFZZpQb71DBg/wRKjeupvKHixGFVuKM=";
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

  meta = {
    description = "Streamlined singularity python client (spython) for singularity";
    homepage = "https://github.com/singularityhub/singularity-cli";
    changelog = "https://github.com/singularityhub/singularity-cli/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "spython";
  };
}
