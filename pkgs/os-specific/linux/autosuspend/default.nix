{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "autosuspend";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "languitar";
    repo = pname;
    rev = "v${version}";
    sha256 = "03qca6avn7bwxcavif7q2nqfzivzp0py7qw3i4hsb28gjrq9nz36";
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
