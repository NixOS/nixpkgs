{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatch-vcs,
  hatchling,

  # tests
  pytest-asyncio,
  pytest-cov-stub,
  pytest-timeout,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "uncalled-for";
  version = "0.3.1";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "chrisguidry";
    repo = "uncalled-for";
    tag = finalAttrs.version;
    hash = "sha256-+akXLsfto3FNbkpsPPwN1DQmvu3BpTafRbqLmLwtqek=";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  pythonImportsCheck = [ "uncalled_for" ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-cov-stub
    pytest-timeout
    pytestCheckHook
  ];

  meta = {
    description = "Async dependency injection for Python functions";
    homepage = "https://github.com/chrisguidry/uncalled-for";
    changelog = "https://github.com/chrisguidry/uncalled-for/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ squat ];
  };
})
