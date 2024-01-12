{ lib
, buildPythonPackage
, fetchFromGitHub

# build-system
, setuptools
, setuptools-scm

# tests
, glibcLocales
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "urwid";
  version = "2.2.3";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "urwid";
    repo = "urwid";
    rev = "refs/tags/${version}";
    hash = "sha256-oPb2h/+gaqkZTXIiESjExMfBNnOzDvoMkXvkZ/+KVwo=";
  };

  postPatch = ''
    sed -i '/addopts =/d' pyproject.toml
  '';

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  nativeCheckInputs = [
    glibcLocales
    pytestCheckHook
  ];

  env.LC_ALL = "en_US.UTF8";

  pytestFlagsArray = [
    "tests"
  ];

  disabledTestPaths = [
    # expect call hangs
    "tests/test_vterm.py"
  ];

  pythonImportsCheck = [
    "urwid"
  ];

  meta = with lib; {
    changelog = "https://github.com/urwid/urwid/releases/tag/${version}";
    description = "A full-featured console (xterm et al.) user interface library";
    downloadPage = "https://github.com/urwid/urwid";
    homepage = "https://urwid.org/";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ ];
  };
}
