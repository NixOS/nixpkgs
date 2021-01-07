{ stdenv
, buildPythonPackage
, fetchFromGitHub
, six
, setuptools_scm
, xorg
, python
, mock
, nose
, util-linux
}:

buildPythonPackage rec {
  pname = "xlib";
  version = "0.29";

  src = fetchFromGitHub {
    owner = "python-xlib";
    repo = "python-xlib";
    rev = version;
    sha256 = "sha256-zOG1QzRa5uN36Ngv8i5s3mq+VIoRzxFj5ltUbKdonJ0=";
  };

  checkPhase = ''
    ${python.interpreter} runtests.py
  '';

  checkInputs = [ mock nose util-linux /* mcookie */ xorg.xauth xorg.xorgserver /* xvfb */ ];
  nativeBuildInputs = [ setuptools_scm ];
  buildInputs = [ xorg.libX11 ];
  propagatedBuildInputs = [ six ];

  doCheck = !stdenv.isDarwin;

  meta = with stdenv.lib; {
    description = "Fully functional X client library for Python programs";
    homepage = "http://python-xlib.sourceforge.net/";
    license = licenses.gpl2Plus;
  };

}
