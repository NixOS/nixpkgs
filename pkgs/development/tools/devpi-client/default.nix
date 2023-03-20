{ lib
, devpi-server
, git
, glibcLocales
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "devpi-client";
  version = "6.0.3";

  format = "setuptools";

  src = python3.pkgs.fetchPypi {
    inherit pname version;
    hash = "sha256-csdQUxnopH+kYtoqdvyXKNW3fGkQNSREJYxjes9Dgi8=";
  };

  postPatch = ''
    substituteInPlace tox.ini \
      --replace "--flake8" ""
  '';

  buildInputs = [
    glibcLocales
  ];

  propagatedBuildInputs = with python3.pkgs; [
    argon2-cffi-bindings
    build
    check-manifest
    devpi-common
    iniconfig
    pep517
    pkginfo
    pluggy
    platformdirs
    py
    setuptools
  ];

  nativeCheckInputs = [
    devpi-server
    git
  ] ++ (with python3.pkgs; [
    mercurial
    mock
    pypitoken
    pytestCheckHook
    sphinx
    virtualenv
    webtest
    wheel
  ]);

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
    description = "Client for devpi, a pypi index server and packaging meta tool";
    homepage = "http://doc.devpi.net";
    changelog = "https://github.com/devpi/devpi/blob/client-${version}/client/CHANGELOG";
    license = licenses.mit;
    maintainers = with maintainers; [ lewo makefu ];
  };
}
