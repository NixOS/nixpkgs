{ lib
, buildPythonPackage
, fetchPypi

# build-system
, setuptools
, setuptools-scm
, wheel

# tests
, glibcLocales
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "urwid";
  version = "2.2.1";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-4zkRqxjyxz/dvpvyFtAh504gstWqm+MEA8WPVRMbuKE=";
  };

  postPatch = ''
    sed -i '/addopts =/d' pyproject.toml
  '';

  nativeBuildInputs = [
    setuptools
    setuptools-scm
    wheel
  ];

  nativeCheckInputs = [
    glibcLocales
    pytestCheckHook
  ];

  env.LC_ALL = "en_US.UTF8";

  disabledTestPaths = [
    # expect call hangs
    "urwid/tests/test_vterm.py"
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
