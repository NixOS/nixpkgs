{ lib
, argon2-cffi-bindings
, buildPythonApplication
, check-manifest
, devpi-common
, devpi-server
, fetchPypi
, git
, glibcLocales
, mercurial
, mock
, pkginfo
, pluggy
, py
, pytestCheckHook
, setuptools
, sphinx
, tox
, webtest
, wheel
}:

buildPythonApplication rec {
  pname = "devpi-client";
  version = "5.2.3";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Ni6ybpUTankkkYYcwnKNFKYwmp1MTxOnucPm/TneWOw=";
  };

  postPatch = ''
    substituteInPlace tox.ini \
      --replace "--flake8" ""
  '';

  buildInputs = [
    glibcLocales
  ];

  propagatedBuildInputs = [
    argon2-cffi-bindings
    check-manifest
    devpi-common
    pkginfo
    pluggy
    py
    setuptools
  ];

  nativeCheckInputs = [
    devpi-server
    git
    mercurial
    mock
    pytestCheckHook
    sphinx
    tox
    webtest
    wheel
  ];

  preCheck = ''
    export HOME=$(mktemp -d);
  '';

  pytestFlagsArray = [
    # --fast skips tests which try to start a devpi-server improperly
    "--fast"
  ];

  LC_ALL = "en_US.UTF-8";

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    homepage = "http://doc.devpi.net";
    description = "Client for devpi, a pypi index server and packaging meta tool";
    license = licenses.mit;
    maintainers = with maintainers; [ lewo makefu ];
  };
}
