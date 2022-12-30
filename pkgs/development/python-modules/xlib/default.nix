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
    sha256 = "sha256-u06OWlMIOUzHOVS4hvm72jGgTSXWUqMvEQd8bTpFog0=";
  };

  patches = [
    ./fix-no-protocol-specified.patch
  ];

  nativeBuildInputs = [ setuptools-scm ];
  buildInputs = [ xorg.libX11 ];
  propagatedBuildInputs = [ six ];

  doCheck = !stdenv.isDarwin;
  checkInputs = [
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
    description = "Fully functional X client library for Python programs";
    homepage = "http://python-xlib.sourceforge.net/";
    license = licenses.gpl2Plus;
  };

}
