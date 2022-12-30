{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "sybil";
  version = "4.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "cjw296";
    repo = "sybil";
    rev = "refs/tags/${version}";
    hash = "sha256-9fXvQfVS3IVdOV4hbA0bEYFJU7uK0WpqJKMNBltqFTI=";
  };

  checkInputs = [
    pytestCheckHook
  ];

  doCheck = false; # requires seedir (unpackaged) and testfixtures (infinite recursion)

  disabledTests = [
    # Sensitive to output of other commands
    "test_namespace"
    "test_unittest"
  ];

  pythonImportsCheck = [
    "sybil"
  ];

  meta = with lib; {
    changelog = "https://github.com/simplistix/sybil/blob/${version}/CHANGELOG.rst";
    description = "Automated testing for the examples in your documentation";
    homepage = "https://github.com/cjw296/sybil";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
