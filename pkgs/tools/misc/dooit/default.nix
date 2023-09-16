{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "dooit";
  version = "2.0.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "kraanzu";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-iQAGD6zrBBd4fJONaB7to1OJpAJUO0zeA1xhVQZBkMc=";
  };

  nativeBuildInputs = with python3.pkgs; [
    poetry-core
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

  meta = with lib; {
    description = "A TUI todo manager";
    homepage = "https://github.com/kraanzu/dooit";
    changelog = "https://github.com/kraanzu/dooit/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ khaneliman wesleyjrz ];
  };
}
