{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "autosuspend";
  version = "4.0.1";

  src = fetchFromGitHub {
    owner = "languitar";
    repo = pname;
    rev = "v${version}";
    sha256 = "149b4qn3nmz48ydnlcgks3as3zzzzn3f5cvj3kdxqxjy4c052lpz";
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

  checkInputs = with python3.pkgs; [
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
