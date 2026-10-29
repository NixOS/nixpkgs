{
  lib,
  async-generator,
  buildPythonPackage,
  fetchFromGitHub,
  importlib-metadata,
  mypy-extensions,
  setuptools,
  trio,
  typing-extensions,
}:

buildPythonPackage (finalAttrs: {
  pname = "trio-typing";
  version = "0.10.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "python-trio";
    repo = "trio-typing";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6IhPdPj+bHzMyt3uyqfX2UOuCmV8lb6vmgdlc5+9/4g=";
  };

  build-system = [ setuptools ];

  dependencies = [
    async-generator
    importlib-metadata
    mypy-extensions
    trio
    typing-extensions
  ];

  pythonImportsCheck = [ "trio_typing" ];

  # Module has no test
  doCheck = false;

  meta = {
    description = "Type hints for Trio and related projects";
    homepage = "https://github.com/python-trio/trio-typing";
    changelog = "https://github.com/python-trio/trio-typing/releases/tag/${finalAttrs.src.tag}";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ fab ];
  };
})
