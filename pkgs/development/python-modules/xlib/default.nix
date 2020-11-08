{ stdenv
, buildPythonPackage
, fetchFromGitHub
, six
, setuptools_scm
, xorg
, python
, mock
, nose
, utillinux
}:

buildPythonPackage rec {
  pname = "xlib";
  version = "0.28";

  src = fetchFromGitHub {
    owner = "python-xlib";
    repo = "python-xlib";
    rev = version;
    sha256 = "13551vi65034pjf2g7zkw5dyjqcjfyk32a640g5jr055ssf0bjkc";
  };

  checkPhase = ''
    ${python.interpreter} runtests.py
  '';

  checkInputs = [ mock nose utillinux /* mcookie */ xorg.xauth xorg.xorgserver /* xvfb */ ];
  nativeBuildInputs = [ setuptools_scm ];
  buildInputs = [ xorg.libX11 ];
  requiredPythonModules = [ six ];

  doCheck = !stdenv.isDarwin;

  meta = with stdenv.lib; {
    description = "Fully functional X client library for Python programs";
    homepage = "http://python-xlib.sourceforge.net/";
    license = licenses.gpl2Plus;
  };

}
