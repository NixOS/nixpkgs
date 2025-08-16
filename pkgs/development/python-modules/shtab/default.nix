{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-timeout,
  pytestCheckHook,
  pytest-cov-stub,
  pythonOlder,
  setuptools,
  setuptools-scm,
  bashInteractive,
}:

buildPythonPackage rec {
  pname = "shtab";
  version = "1.7.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "iterative";
    repo = "shtab";
    tag = "v${version}";
    hash = "sha256-ngTAST+6lBek0PHvULmlJZAHVU49YN5+XAu5KEk6cIM=";
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

  meta = with lib; {
    description = "Module for shell tab completion of Python CLI applications";
    mainProgram = "shtab";
    homepage = "https://docs.iterative.ai/shtab/";
    changelog = "https://github.com/iterative/shtab/releases/tag/${src.tag}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
