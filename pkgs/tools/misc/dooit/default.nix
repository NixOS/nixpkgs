{ lib
, fetchFromGitHub
, dooit
, python3
, testers
}:

python3.pkgs.buildPythonApplication rec {
  pname = "dooit";
  version = "2.1.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "kraanzu";
    repo = "dooit";
    rev = "v${version}";
    hash = "sha256-ZCEBpaQHaFb09MUlN6acYB3LrfX456uRbhVh9YPz7NU=";
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

  # NOTE pyproject version was bumped after release tag 2.0.1 - remove after next release.
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "version = \"2.0.0\"" "version = \"2.0.1\""
  '';

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
