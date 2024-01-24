{ lib
, buildPythonApplication
, fetchFromGitHub
, hatchling
, hatch-requirements-txt
, hatch-vcs
, pyserial
, importlib-metadata
}:
buildPythonApplication rec {
  pname = "mpremote";
  version = "1.22.1";

  src = fetchFromGitHub {
    owner = "micropython";
    repo = "micropython";
    rev = "refs/tags/v${version}";
    hash = "sha256-tGFXJW1RkUs/64Yatgg/1zZFPDQdu76uiMjNU8ebdvg=";
  };
  sourceRoot = "source/tools/mpremote";
  format = "pyproject";

  nativeBuildInputs = [
    hatchling
    hatch-requirements-txt
    hatch-vcs
  ];
  propagatedBuildInputs = [
    pyserial
    importlib-metadata
  ];

  pythonImportsCheck = [ "mpremote" ];

  meta = with lib; {
    description = "An integrated set of utilities to remotely interact with and automate a MicroPython device over a serial connection";
    homepage = "https://github.com/micropython/micropython/blob/master/tools/mpremote/README.md";
    platforms = platforms.unix;
    license = licenses.mit;
    maintainers = with maintainers; [ _999eagle ];
    mainProgram = "mpremote";
  };
}
