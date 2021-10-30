{ lib
, pkgs
, python3
, fetchFromGitHub
, platformio
, esptool
, git
}:

let
  python = python3.override {
    packageOverrides = self: super: {
      esphome-dashboard = pkgs.callPackage ./dashboard.nix {};
    };
  };
in
with python.pkgs; buildPythonApplication rec {
  pname = "esphome";
  version = "2021.10.1";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "sha256-zVZantMYtDWkvFrXmX0HpUchmc3T2gbkrMiWGP2ibNc=";
  };

  patches = [
    # fix missing write permissions on src files before modifing them
   ./fix-src-permissions.patch
  ];

  postPatch = ''
    # remove all version pinning (E.g tornado==5.1.1 -> tornado)
    sed -i -e "s/==[0-9.]*//" requirements.txt

    # drop coverage testing
    sed -i '/--cov/d' pytest.ini
  '';

  # Remove esptool and platformio from requirements
  ESPHOME_USE_SUBPROCESS = "";

  # esphome has optional dependencies it does not declare, they are
  # loaded when certain config blocks are used, like `font`, `image`
  # or `animation`.
  # They have validation functions like:
  # - validate_cryptography_installed
  # - validate_pillow_installed
  propagatedBuildInputs = [
    aioesphomeapi
    click
    colorama
    cryptography
    esphome-dashboard
    ifaddr
    kconfiglib
    paho-mqtt
    pillow
    protobuf
    pyserial
    pyyaml
    tornado
    tzdata
    tzlocal
    voluptuous
  ];

  makeWrapperArgs = [
    # platformio is used in esphomeyaml/platformio_api.py
    # esptool is used in esphomeyaml/__main__.py
    # git is used in esphomeyaml/writer.py
    "--prefix PATH : ${lib.makeBinPath [ platformio esptool git ]}"
    "--set ESPHOME_USE_SUBPROCESS ''"
  ];

  checkInputs = [
    hypothesis
    mock
    pytest-asyncio
    pytest-mock
    pytest-sugar
    pytestCheckHook
  ];

  disabledTestPaths = [
    # requires hypothesis 5.49, we have 6.x
    # ImportError: cannot import name 'ip_addresses' from 'hypothesis.provisional'
    "tests/unit_tests/test_core.py"
    "tests/unit_tests/test_helpers.py"
  ];

  postCheck = ''
    $out/bin/esphome --help > /dev/null
  '';

  passthru = {
    dashboard = esphome-dashboard;
  };

  meta = with lib; {
    description = "Make creating custom firmwares for ESP32/ESP8266 super easy";
    homepage = "https://esphome.io/";
    license = with licenses; [
      mit # The C++/runtime codebase of the ESPHome project (file extensions .c, .cpp, .h, .hpp, .tcc, .ino)
      gpl3Only # The python codebase and all other parts of this codebase
    ];
    maintainers = with maintainers; [ globin elseym hexa ];
  };
}
