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
  version = "1.20.0";

  src = fetchFromGitHub {
    owner = "micropython";
    repo = "micropython";
    rev = "v${version}";
    hash = "sha256-udIyNcRjwwoWju0Qob0CFtMibbVKwc7j2ji83BC1rX0=";
  };
  sourceRoot = "source/tools/mpremote";
  format = "pyproject";
  env.SETUPTOOLS_SCM_PRETEND_VERSION = version;

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
  };
}
