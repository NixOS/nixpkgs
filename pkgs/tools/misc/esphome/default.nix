{ lib
, callPackage
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
python.pkgs.buildPythonApplication rec {
  pname = "esphome";
  version = "2023.9.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-svWRR5ePlMiLNfTtuhabp9HhQn4/ioUC6jPbEMDr/w8=";
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
  propagatedBuildInputs = with python.pkgs; [
    aioesphomeapi
    click
    colorama
    cryptography
    esphome-dashboard
    kconfiglib
    paho-mqtt
    pillow
    platformio
    protobuf
    pyparsing
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

  nativeCheckInputs = with python.pkgs; [
    hypothesis
    mock
    pytest-asyncio
    pytest-mock
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
    dashboard = python.pkgs.esphome-dashboard;
    updateScript = callPackage ./update.nix {};
  };

  meta = with lib; {
    changelog = "https://github.com/esphome/esphome/releases/tag/${version}";
    description = "Make creating custom firmwares for ESP32/ESP8266 super easy";
    homepage = "https://esphome.io/";
    license = with licenses; [
      mit # The C++/runtime codebase of the ESPHome project (file extensions .c, .cpp, .h, .hpp, .tcc, .ino)
      gpl3Only # The python codebase and all other parts of this codebase
    ];
    maintainers = with maintainers; [ globin hexa ];
  };
}
