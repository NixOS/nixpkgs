{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "sensai-utils";
  version = "1.4.0";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "opcode81";
    repo = "sensAI-utils";
    tag = "v${version}";
    hash = "sha256-XgZv76tLeTRCvNptasp8EiU2DC+HWkc1xhlCA+YiUZY=";
  };

  build-system = [ setuptools ];

  dependencies = [ typing-extensions ];

  pythonImportsCheck = [ "sensai.util" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Utilities from sensAI, the Python library for sensible AI";
    homepage = "https://github.com/opcode81/sensAI-utils";
    changelog = "https://github.com/opcode81/sensAI-utils/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ derdennisop ];
  };
}
