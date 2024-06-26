{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "validators";
  version = "0.28.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "python-validators";
    repo = "validators";
    rev = "refs/tags/${version}";
    hash = "sha256-hyk89eLHG3t2om5YB2KdiAHqSk0AYpGaTdy5wkxfw0Y=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "validators" ];

  meta = with lib; {
    description = "Python Data Validation for Humans";
    homepage = "https://github.com/python-validators/validators";
    changelog = "https://github.com/python-validators/validators/blob/${version}/CHANGES.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
