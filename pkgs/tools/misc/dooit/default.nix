{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "dooit";
  version = "2.0.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "kraanzu";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-4D8X+VtESII1c2b7r6BeCbeULW25uki3y4TcNER/zZU=";
  };

  # Required versions not available
  pythonRelaxDeps = [
    "textual"
    "tzlocal"
  ];

  nativeBuildInputs = with python3.pkgs; [
    poetry-core
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = with python3.pkgs; [
    textual
    pyperclip
    pyyaml
    dateparser
    tzlocal
    appdirs
  ];

  # No tests available
  doCheck = false;

  meta = with lib; {
    description = "A TUI todo manager";
    homepage = "https://github.com/kraanzu/dooit";
    changelog = "https://github.com/kraanzu/dooit/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ wesleyjrz ];
  };
}
