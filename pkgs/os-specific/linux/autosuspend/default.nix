{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "autosuspend";
  version = "4.3.0";

  src = fetchFromGitHub {
    owner = "languitar";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-gS8NNks4GaIGl7cEqWSP53I4/tIV4LypkmZ5vNOjspY=";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace '--cov-config=setup.cfg' ""
  '';

  propagatedBuildInputs = with python3.pkgs; [
    portalocker
    psutil
    dbus-python
  ];

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
    python-dbusmock
    pytest-httpserver
    dateutils
    freezegun
    pytest-mock
    requests
    requests-file
    icalendar
    tzlocal
    jsonpath-ng
    mpd2
    lxml
    pytest-datadir
  ];

  # Disable tests that need root
  disabledTests = [
    "test_smoke"
    "test_multiple_sessions"
  ];

  doCheck = true;

  meta = with lib ; {
    description = "A daemon to automatically suspend and wake up a system";
    homepage = "https://autosuspend.readthedocs.io";
    license = licenses.gpl2Only;
    maintainers = [ maintainers.bzizou ];
    platforms = platforms.linux;
  };
}
