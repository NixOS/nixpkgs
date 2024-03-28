{ lib, fetchFromGitHub, python3 }:

let
  inherit (lib) licenses maintainers;

  inherit (python3.pkgs)
    buildPythonApplication
    click
    jsonschema
    pytestCheckHook
    pytest-xdist
    pythonOlder
    regress
    requests
    responses
    ruamel-yaml
    setuptools
    ;
in

buildPythonApplication rec {
  pname = "check-jsonschema";
  version = "0.28.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "python-jsonschema";
    repo = "check-jsonschema";
    rev = "refs/tags/${version}";
    hash = "sha256-qcY846y8xLEsPfdtzoOfxo5gdggH6Dn3QkQOY7kMwm0=";
  };

  propagatedBuildInputs = [
    ruamel-yaml
    jsonschema
    requests
    click
    regress
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

  disabledTests = [
    "test_schemaloader_yaml_data"
  ];

  meta = {
    description = "A jsonschema CLI and pre-commit hook";
    mainProgram = "check-jsonschema";
    homepage = "https://github.com/python-jsonschema/check-jsonschema";
    changelog = "https://github.com/python-jsonschema/check-jsonschema/blob/${version}/CHANGELOG.rst";
    license = licenses.asl20;
    maintainers = with maintainers; [ sudosubin ];
  };
}
