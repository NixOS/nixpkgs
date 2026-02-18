{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "sensai-utils";
  version = "1.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "opcode81";
    repo = "sensAI-utils";
    tag = "v${version}";
    hash = "sha256-E/9pCkSvKeGW1wlO6+YD0glbPrt4aJ7NZ0Kss2VbGdE=";
  };

  build-system = [ setuptools ];

  dependencies = [ typing-extensions ];

  pythonImportsCheck = [ "sensai.util" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Utilities from sensAI, the Python library for sensible AI";
    homepage = "https://github.com/opcode81/sensAI-utils";
    changelog = "https://github.com/opcode81/sensAI-utils/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ derdennisop ];
  };
}
