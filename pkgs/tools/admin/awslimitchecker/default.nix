{ lib, python3Packages, fetchFromGitHub }:

python3Packages.buildPythonApplication rec {
  pname = "awslimitchecker";
  version = "12.0.0";

  src = fetchFromGitHub {
    owner = "jantman";
    repo = "awslimitchecker";
    rev = version;
    sha256 = "1p6n4kziyl6sfq7vgga9v88ddwh3sgnfb1m1cx6q25n0wyl7phgv";
  };

  propagatedBuildInputs = with python3Packages; [
    boto3
    botocore
    pytz
    termcolor
    versionfinder
  ];

  nativeCheckInputs = with python3Packages; [
    freezegun
    onetimepass
    pytestCheckHook
    pyotp
    testfixtures
  ];

  patches = [
    # Fix the version lookup to use only the hardcoded version in the source package
    ./version.patch
  ];

  pytestFlagsArray = [
    "awslimitchecker/tests"
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
    homepage = "http://awslimitchecker.readthedocs.org";
    changelog = "https://github.com/jantman/awslimitchecker/blob/${version}/CHANGES.rst";
    description = "A script and python package to check your AWS service limits and usage via boto3";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ zakame ];
  };
}
