{ lib
, python3
, fetchFromGitHub
, nixosTests
}:

with python3.pkgs; buildPythonApplication rec {
  pname = "pinnwand";
  version = "1.4.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "supakeen";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-zJH2ojLQChElRvU2TWg4lW+Mey+wP0XbLJhVF16nvss=";
  };

  nativeBuildInputs = [
    poetry-core
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [
    "docutils"
    "sqlalchemy"
  ];

  propagatedBuildInputs = [
    click
    docutils
    pygments
    pygments-better-html
    sqlalchemy
    token-bucket
    tomli
    tornado
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  __darwinAllowLocalNetworking = true;

  passthru.tests = nixosTests.pinnwand;

  meta = with lib; {
    changelog = "https://github.com/supakeen/pinnwand/releases/tag/v${version}";
    description = "A Python pastebin that tries to keep it simple";
    homepage = "https://supakeen.com/project/pinnwand/";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
    mainProgram = "pinnwand";
  };
}

