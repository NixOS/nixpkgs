{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "validators";
  version = "0.22.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "python-validators";
    repo = "validators";
    rev = "refs/tags/${version}";
    hash = "sha256-Qu6Tu9uIluT1KBJYkFjDFt9AWN2Kez3uCYDQknXqYrU=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "validators"
  ];

  meta = with lib; {
    description = "Python Data Validation for Humans";
    homepage = "https://github.com/python-validators/validators";
    changelog = "https://github.com/python-validators/validators/blob/${version}/CHANGES.md";
    license = licenses.mit;
    maintainers = [ ];
  };
}
