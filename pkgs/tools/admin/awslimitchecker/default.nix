{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "awslimitchecker";
  version = "12.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jantman";
    repo = "awslimitchecker";
    rev = "refs/tags/${version}";
    hash = "sha256-+8F7qOfAFoFNZ6GG5ezTA/LWENpJvbcPdtpQH/8k1tw=";
  };

  patches = [
    # Fix the version lookup to use only the hardcoded version in the source package
    ./version.patch
  ];

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [
    boto3
    botocore
    pytz
    termcolor
    versionfinder
  ];

  nativeCheckInputs = with python3.pkgs; [
    freezegun
    onetimepass
    pyotp
    mock
    (pytestCheckHook.override { pytest = pytest_7; })
    testfixtures
  ];

  disabledTestPaths = [
    # AWS tests that use the network
    "awslimitchecker/tests/services"
    "awslimitchecker/tests/test_checker.py"
    "awslimitchecker/tests/test_runner.py"

    # the version lookup tests as patched above
    "awslimitchecker/tests/test_version.py"
  ];

  pythonImportsCheck = [ "awslimitchecker.checker" ];

  meta = with lib; {
    description = "Script and python package to check your AWS service limits and usage via boto3";
    homepage = "http://awslimitchecker.readthedocs.org";
    changelog = "https://github.com/jantman/awslimitchecker/blob/${version}/CHANGES.rst";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ zakame ];
    mainProgram = "awslimitchecker";
  };
}
