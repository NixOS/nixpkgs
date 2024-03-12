{ lib
, buildPythonPackage
, fetchFromGitHub
, pytest-timeout
, pytestCheckHook
, pythonOlder
, setuptools
, setuptools-scm
, bashInteractive
}:

buildPythonPackage rec {
  pname = "shtab";
  version = "1.7.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "iterative";
    repo = "shtab";
    rev = "refs/tags/v${version}";
    hash = "sha256-b2XXDyO/2AnlxViC6sEEYUGviF6+FGXBnBcdQOuTViY=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail " --cov=shtab --cov-report=term-missing --cov-report=xml" ""
  '';

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  nativeCheckInputs = [
    bashInteractive
    pytest-timeout
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "shtab"
  ];

  meta = with lib; {
    description = "Module for shell tab completion of Python CLI applications";
    homepage = "https://docs.iterative.ai/shtab/";
    changelog = "https://github.com/iterative/shtab/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
