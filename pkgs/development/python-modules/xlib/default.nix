{ lib, stdenv
, buildPythonPackage
, fetchFromGitHub
, six
, setuptools-scm
, xorg
, python
, mock
, nose
, pytestCheckHook
, util-linux
}:

buildPythonPackage rec {
  pname = "xlib";
  version = "0.33";

  src = fetchFromGitHub {
    owner = "python-xlib";
    repo = "python-xlib";
    rev = "refs/tags/${version}";
    hash = "sha256-u06OWlMIOUzHOVS4hvm72jGgTSXWUqMvEQd8bTpFog0=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  buildInputs = [
    xorg.libX11
  ];

  propagatedBuildInputs = [
    six
  ];

  doCheck = !stdenv.isDarwin;

  nativeCheckInputs = [
    pytestCheckHook
    mock
    nose
    util-linux
    xorg.xauth
    xorg.xorgserver
  ];

  disabledTestPaths = [
    # requires x session
    "test/test_xlib_display.py"
  ];

  meta = with lib; {
    changelog = "https://github.com/python-xlib/python-xlib/releases/tag/${version}";
    description = "Fully functional X client library for Python programs";
    homepage = "https://github.com/python-xlib/python-xlib";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ ];
  };

}
