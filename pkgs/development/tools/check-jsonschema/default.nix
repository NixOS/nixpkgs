{ lib, fetchFromGitHub, python3 }:

with python3.pkgs;

buildPythonApplication rec {
  pname = "check-jsonschema";
  version = "0.23.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "python-jsonschema";
    repo = "check-jsonschema";
    rev = version;
    hash = "sha256-gPFG1AgInakF8leMM0c1zZt2OdZdIKcUmItwICV8p1I=";
  };

  propagatedBuildInputs = [
    ruamel-yaml
    jsonschema
    requests
    click
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-xdist
    responses
  ];

  pythonImportsCheck = [
    "check_jsonschema"
    "check_jsonschema.cli"
  ];

  meta = with lib; {
    description = "A jsonschema CLI and pre-commit hook";
    homepage = "https://github.com/python-jsonschema/check-jsonschema";
    changelog = "https://github.com/python-jsonschema/check-jsonschema/blob/${version}/CHANGELOG.rst";
    license = licenses.asl20;
    maintainers = with maintainers; [ sudosubin ];
  };
}
