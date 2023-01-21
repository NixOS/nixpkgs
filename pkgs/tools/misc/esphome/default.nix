{ lib
, python3
, fetchFromGitHub
, platformio
, esptool_3
, git
}:

let
  python = python3.override {
    packageOverrides = self: super: {
      esphome-dashboard = self.callPackage ./dashboard.nix {};
    };
  };
in
with python.pkgs; buildPythonApplication rec {
  pname = "esphome";
  version = "2022.12.4";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-HU4S6U5v0r93z4T6JpclEF6Cw6vy0VoprVyI4Z2Ti7s=";
  };

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
    platformio
    protobuf
    pyserial
    pyyaml
    requests
    tornado
    tzdata
    tzlocal
    voluptuous
  ];

  makeWrapperArgs = [
    # platformio is used in esphomeyaml/platformio_api.py
    # esptool is used in esphomeyaml/__main__.py
    # git is used in esphomeyaml/writer.py
    "--prefix PATH : ${lib.makeBinPath [ platformio esptool_3 git ]}"
    "--set ESPHOME_USE_SUBPROCESS ''"
  ];

  nativeCheckInputs = [
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
    updateScript = callPackage ./update.nix {};
  };

  meta = with lib; {
    description = "Make creating custom firmwares for ESP32/ESP8266 super easy";
    homepage = "https://esphome.io/";
    license = with licenses; [
      mit # The C++/runtime codebase of the ESPHome project (file extensions .c, .cpp, .h, .hpp, .tcc, .ino)
      gpl3Only # The python codebase and all other parts of this codebase
    ];
    maintainers = with maintainers; [ globin hexa ];
  };
}
