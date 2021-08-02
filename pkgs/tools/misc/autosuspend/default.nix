{ lib
, stdenv
, pkgs
, python3
, installShellFiles
, fetchFromGitHub
}:

with python3.pkgs; buildPythonApplication rec {
  pname = "autosuspend";
  version = "3.1.3";

  src = fetchFromGitHub {
    owner = "languitar";
    repo = "autosuspend";
    rev = "v${version}";
    sha256 = "0lms0q5nmywlxph3qqh7vp13pcj49l1fh0yxl23ljfnl5v9lwhjl";
  };

  propagatedBuildInputs = [
    dbus-python
    mpd2
    requests
    lxml
    icalendar
    dateutil
    tzlocal
    freezegun
    jsonpath-ng
    portalocker
    psutil
  ];

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = [
    sphinx
    sphinx-issues
    sphinx-autodoc-typehints
    sphinxcontrib-plantuml
    recommonmark
  ];

  checkInputs = [
    pytestCheckHook
    pytest-cov
    pytest-datadir
    pytest-mock
    pytest-httpserver
    python-dbusmock
  ];

  disabledTests = [
    "TestXIdleTime" # doesn't like $HOME of build user
    "TestNetworkMixin" # requires network
  ];

  postInstall = ''
    ${python3.interpreter} setup.py build_sphinx -a -b man
    installManPage doc/build/man/{autosuspend.1,autosuspend.conf.5}
  '';

  meta = with lib; {
    homepage = "https://autosuspend.readthedocs.io";
    description = "Python daemon that suspends a system if certain conditions are met, or not met";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ maggicl ];
  };
}
