{ lib
, python3
, fetchFromGitHub
, fetchpatch2
, nixosTests
}:

with python3.pkgs; buildPythonApplication rec {
  pname = "pinnwand";
  version = "1.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "supakeen";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-1Q/jRjFUoJb1S3cGF8aVuguWMJwYrAtXdKpZV8nRK0k=";
  };

  patches = [
    (fetchpatch2 {
      # fix entrypoint
      url = "https://github.com/supakeen/pinnwand/commit/7868b4b4dcd57066dd0023b5a3cbe91fc5a0a858.patch";
      hash = "sha256-Fln9yJNRvNPHZ0JIgzmwwjUpAHMu55NaEb8ZVDWhLyE=";
    })
  ];

  nativeBuildInputs = [
    pdm-pep517
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
    python-dotenv
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
    description = "Python pastebin that tries to keep it simple";
    homepage = "https://supakeen.com/project/pinnwand/";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
    mainProgram = "pinnwand";
  };
}

