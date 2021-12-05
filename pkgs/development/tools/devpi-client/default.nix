{ lib, buildPythonApplication, fetchPypi
# buildInputs
, glibcLocales, pkginfo, check-manifest
# propagatedBuildInputs
, py, devpi-common, pluggy, setuptools
# CheckInputs
, pytest, pytest-flake8, webtest, mock, devpi-server, tox, sphinx, wheel, git
, mercurial }:

buildPythonApplication rec {
  pname = "devpi-client";
  version = "5.2.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "362eb26e95136a792491861cc2728d14a6309a9d4c4f13a7b9c3e6fd39de58ec";
  };

  buildInputs = [ glibcLocales ];

  propagatedBuildInputs =
    [ py devpi-common pluggy setuptools check-manifest pkginfo ];

  checkInputs = [
    pytest
    pytest-flake8
    webtest
    mock
    devpi-server
    tox
    sphinx
    wheel
    git
    mercurial
  ];

  # --fast skips tests which try to start a devpi-server improperly
  checkPhase = ''
    HOME=$TMPDIR py.test --fast
  '';

  LC_ALL = "en_US.UTF-8";

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    homepage = "http://doc.devpi.net";
    description =
      "Client for devpi, a pypi index server and packaging meta tool";
    license = licenses.mit;
    maintainers = with maintainers; [ lewo makefu ];
  };

}
