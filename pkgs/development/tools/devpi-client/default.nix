{ stdenv
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
  version = "5.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1y8r1pjav0gyrbnyqjnc202sa962n1gasi8233xj7jc39lv3iq40";
  };

  buildInputs = [ glibcLocales pkginfo check-manifest ];

  propagatedBuildInputs = [ py devpi-common pluggy setuptools ];

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

  meta = with stdenv.lib; {
    homepage = "http://doc.devpi.net";
    description = "Client for devpi, a pypi index server and packaging meta tool";
    license = licenses.mit;
    maintainers = with maintainers; [ lewo makefu ];
  };

}
