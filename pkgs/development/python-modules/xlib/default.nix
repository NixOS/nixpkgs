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
  version = "0.31";

  src = fetchFromGitHub {
    owner = "python-xlib";
    repo = "python-xlib";
    rev = version;
    sha256 = "155p9xhsk01z9vdml74h07svlqy6gljnx9c6qbydcr14lwghwn06";
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
