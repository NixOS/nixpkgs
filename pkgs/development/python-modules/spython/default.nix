{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "spython";
  version = "0.3.12";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "singularityhub";
    repo = "singularity-cli";
    rev = "refs/tags/${version}";
    hash = "sha256-fRtqOpDgVMYlVDwbPkrnpd7PT4fV+2WS6RmpJoxaKdQ=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace '"pytest-runner"' ""
  '';

  nativeBuildInputs = [
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "spython"
  ];

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

  meta = with lib; {
    description = "Streamlined singularity python client (spython) for singularity";
    homepage = "https://github.com/singularityhub/singularity-cli";
    changelog = "https://github.com/singularityhub/singularity-cli/blob/${version}/CHANGELOG.md";
    license = licenses.mpl20;
    maintainers = with maintainers; [ fab ];
  };
}
