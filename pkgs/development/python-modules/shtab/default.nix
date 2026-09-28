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
  version = "1.9.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tqdm";
    repo = "shtab";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+9M0IfiD5CJcg4AHqCfq1UON/E63etwzvx7Gc82H0PE=";
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
    description = "Automagic shell tab completion for Python CLI applications";
    mainProgram = "shtab";
    homepage = "https://tqdm.github.io/shtab/";
    changelog = "https://github.com/tqdm/shtab/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
