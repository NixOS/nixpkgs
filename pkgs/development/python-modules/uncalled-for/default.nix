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
  version = "0.6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "chrisguidry";
    repo = "uncalled-for";
    tag = finalAttrs.version;
    hash = "sha256-Gb7WN5uWqMpIE8CRMf1eJWxrr9Mjue1iN63xHKLW/q4=";
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
