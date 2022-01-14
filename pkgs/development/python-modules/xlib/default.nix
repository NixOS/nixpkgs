{ lib, stdenv
, buildPythonPackage
, fetchFromGitHub
, six
, setuptools-scm
, xorg
, python
, mock
, nose
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

  checkPhase = ''
    ${python.interpreter} runtests.py
  '';

  checkInputs = [ mock nose util-linux /* mcookie */ xorg.xauth xorg.xorgserver /* xvfb */ ];
  nativeBuildInputs = [ setuptools-scm ];
  buildInputs = [ xorg.libX11 ];
  propagatedBuildInputs = [ six ];

  doCheck = !stdenv.isDarwin;

  meta = with lib; {
    description = "Fully functional X client library for Python programs";
    homepage = "http://python-xlib.sourceforge.net/";
    license = licenses.gpl2Plus;
  };

}
