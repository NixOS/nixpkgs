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
  version = "0.32";

  src = fetchFromGitHub {
    owner = "python-xlib";
    repo = "python-xlib";
    rev = version;
    hash = "sha256-ATe03X9DZWftuGCm1FyEjcCUttbAMWENMQ6wZsruBPA=";
  };

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
