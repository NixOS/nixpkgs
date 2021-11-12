{ lib
, buildPythonApplication
, fetchPypi
# buildInputs
, glibcLocales
, pkginfo
, check-manifest
# propagatedBuildInputs
, py
, devpi-common
, pluggy
, setuptools
# CheckInputs
, pytest
, pytest-flake8
, webtest
, mock
, devpi-server
, tox
, sphinx
, wheel
, git
, mercurial
}:

buildPythonApplication rec {
  pname = "devpi-client";
  version = "5.2.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "24ac6d94108996efad4ff5185dabb1e5120ae238134b8175d6de2ca9e766cd92";
  };

  postPatch = ''
    # can be removed after 5.2.2, updated upstream
    substituteInPlace setup.py \
      --replace "pluggy>=0.6.0,<1.0" "pluggy"
  '';

  buildInputs = [ glibcLocales ];

  propagatedBuildInputs = [ py devpi-common pluggy setuptools check-manifest pkginfo ];

  checkInputs = [
    pytest pytest-flake8 webtest mock
    devpi-server tox
    sphinx wheel git mercurial
  ];

  # --fast skips tests which try to start a devpi-server improperly
  checkPhase = ''
    HOME=$TMPDIR py.test --fast
  '';

  LC_ALL = "en_US.UTF-8";

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    homepage = "http://doc.devpi.net";
    description = "Client for devpi, a pypi index server and packaging meta tool";
    license = licenses.mit;
    maintainers = with maintainers; [ lewo makefu ];
  };

}
