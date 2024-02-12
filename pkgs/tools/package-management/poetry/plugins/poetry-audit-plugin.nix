{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, poetry-core
, poetry
, safety
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "poetry-audit-plugin";
  version = "0.3.0";

  disabled = pythonOlder "3.7";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "opeco17";
    repo = "poetry-audit-plugin";
    rev = "refs/tags/${version}";
    hash = "sha256-49OnYz3EFiqOe+cLgfynjy14Ve4Ga6OUrLdM8HhZuKQ=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  buildInputs = [
    poetry
  ];

  propagatedBuildInputs = [
    safety
  ];

  pythonImportsCheck = [ "poetry_audit_plugin" ];

  nativeCheckInputs = [
    poetry  # for the executable
    pytestCheckHook
  ];

  # requires networking
  doCheck = false;

  meta = {
    description = "Poetry plugin for checking security vulnerabilities in dependencies";
    homepage = "https://github.com/opeco17/poetry-audit-plugin";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
