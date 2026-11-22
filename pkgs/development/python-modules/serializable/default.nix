{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
  typechecks,
}:

buildPythonPackage (finalAttrs: {
  pname = "serializable";
  version = "1.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openvax";
    repo = "serializable";
    tag = "v${finalAttrs.version}";
    hash = "sha256-AvwoXxCWs2RF6F15mjrce84Vmg1N53V6Jk/HoOW/R70=";
  };

  build-system = [ setuptools ];

  dependencies = [ typechecks ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "serializable" ];

  meta = {
    description = "Base class with serialization methods for user-defined Python objects";
    homepage = "https://github.com/openvax/serializable";
    changelog = "https://github.com/openvax/serializable/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ samuela ];
  };
})
