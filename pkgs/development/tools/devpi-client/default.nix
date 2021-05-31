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
  version = "5.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "74ff365efeaa7b78c9eb7f6d7bd349ccd6252a6cdf879bcb4137ee5ff0fb127a";
  };

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
