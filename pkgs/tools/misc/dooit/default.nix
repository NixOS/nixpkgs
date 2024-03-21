{ lib
, fetchFromGitHub
, dooit
, python3
, testers
}:

python3.pkgs.buildPythonApplication rec {
  pname = "dooit";
  version = "2.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kraanzu";
    repo = "dooit";
    rev = "v${version}";
    hash = "sha256-GtXRzj+o+FClleh73kqelk0JrSyafZhf847lX1BiS9k=";
  };

  nativeBuildInputs = with python3.pkgs; [
    poetry-core
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [
    "textual"
    "tzlocal"
  ];

  propagatedBuildInputs = with python3.pkgs; [
    appdirs
    pyperclip
    python-dateutil
    pyyaml
    textual
    tzlocal
  ];

  # No tests available
  doCheck = false;

  passthru.tests.version = testers.testVersion {
    package = dooit;
    command = "HOME=$(mktemp -d) dooit --version";
  };

  meta = with lib; {
    description = "A TUI todo manager";
    homepage = "https://github.com/kraanzu/dooit";
    changelog = "https://github.com/kraanzu/dooit/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ khaneliman wesleyjrz ];
    mainProgram = "dooit";
  };
}
