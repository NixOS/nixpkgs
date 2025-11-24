{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch2,
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

  patches = [
    # Fix bash error on optional nargs="?" (iterative/shtab#184)
    (fetchpatch2 {
      url = "https://github.com/iterative/shtab/commit/a04ddf92896f7e206c9b19d48dcc532765364c59.patch?full_index=1";
      hash = "sha256-H4v81xQLI9Y9R5OyDPJevCLh4gIUaiJKHVEU/eWdNbA=";
    })
  ];

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
