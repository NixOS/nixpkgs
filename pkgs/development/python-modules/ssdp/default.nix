{
  lib,
  buildPythonPackage,
  click,
  fetchFromGitHub,
  flit-core,
  flit-scm,
  pygments,
  pytest-cov-stub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "ssdp";
  version = "1.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "codingjoe";
    repo = "ssdp";
    tag = version;
    hash = "sha256-HsU67vsJvoVyOy2QEq8leYcjl1EVdQ039jN1QyL0XgU=";
  };

  build-system = [
    flit-core
    flit-scm
  ];

  optional-dependencies = {
    cli = [
      click
      pygments
    ];
    pygments = [ pygments ];
  };

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "ssdp" ];

  meta = {
    description = "Python asyncio library for Simple Service Discovery Protocol (SSDP)";
    homepage = "https://github.com/codingjoe/ssdp";
    changelog = "https://github.com/codingjoe/ssdp/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "ssdp";
  };
}
