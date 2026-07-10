{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-timeout,
  pytestCheckHook,
  pytest-cov-stub,
  setuptools,
  setuptools-scm,
  bashInteractive,
}:

buildPythonPackage (finalAttrs: {
  pname = "shtab";
  version = "1.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "iterative";
    repo = "shtab";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VK3+JLb9Lh+YHixMa1Hjm5bYJ9vSmMPIkN6c3DeHDo8=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  nativeCheckInputs = [
    bashInteractive
    pytest-timeout
    pytestCheckHook
    pytest-cov-stub
  ];

  pythonImportsCheck = [ "shtab" ];

  meta = {
    description = "Module for shell tab completion of Python CLI applications";
    mainProgram = "shtab";
    homepage = "https://docs.iterative.ai/shtab/";
    changelog = "https://github.com/iterative/shtab/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
