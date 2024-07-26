{ lib
, fetchFromGitHub
, fetchPypi
, python3
}:

let
  python = python3.override {
    packageOverrides = self: super: {
      # autosuspend is incompatible with tzlocal v5
      # See https://github.com/regebro/tzlocal#api-change
      tzlocal = super.tzlocal.overridePythonAttrs (prev: rec {
        version = "4.3.1";
        src = fetchPypi {
          inherit (prev) pname;
          inherit version;
          hash = "sha256-7jLvjCCAPBmpbtNmrd09SnKe9jCctcc1mgzC7ut/pGo=";
        };
        propagatedBuildInputs = with self; [
          pytz-deprecation-shim
        ];
      });
    };
  };
in
python.pkgs.buildPythonApplication rec {
  pname = "autosuspend";
  version = "6.0.0";

  disabled = python3.pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "languitar";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-gS8NNks4GaIGl7cEqWSP53I4/tIV4LypkmZ5vNOjspY=";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace '--cov-config=setup.cfg' ""
  '';

  propagatedBuildInputs = with python.pkgs; [
    dbus-python
    icalendar
    jsonpath-ng
    lxml
    mpd2
    portalocker
    psutil
    python-dateutil
    pytz
    requests
    requests-file
    tzlocal
  ];

  nativeCheckInputs = with python.pkgs; [
    freezegun
    pytest-datadir
    pytest-httpserver
    pytest-mock
    pytestCheckHook
    python-dbusmock
  ];

  # Disable tests that need root
  disabledTests = [
    "test_smoke"
    "test_multiple_sessions"
  ];

  doCheck = true;

  meta = with lib; {
    description = "A daemon to automatically suspend and wake up a system";
    homepage = "https://autosuspend.readthedocs.io";
    changelog = "https://github.com/languitar/autosuspend/releases/tag/v${version}";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ bzizou anthonyroussel ];
    mainProgram = "autosuspend";
    platforms = platforms.linux;
  };
}
