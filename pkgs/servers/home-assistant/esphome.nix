{ lib, python3, fetchpatch, platformio, esptool, git, protobuf3_7 }:

let
  python = python3.override {
    packageOverrides = self: super: {
      pyyaml = super.pyyaml.overridePythonAttrs (oldAttrs: rec {
        version = "5.1";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "436bc774ecf7c103814098159fbb84c2715d25980175292c648f2da143909f95";
        };
      });
      tornado = super.tornado.overridePythonAttrs (oldAttrs: rec {
        version = "5.1.1";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "4e5158d97583502a7e2739951553cbd88a72076f152b4b11b64b9a10c4c49409";
        };
      });
      protobuf = super.protobuf.override {
        protobuf = protobuf3_7;
      };
    };
  };

in python.pkgs.buildPythonApplication rec {
  pname = "esphome";
  version = "1.12.2";

  src = python.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "935fc3d0f05b2f5911c29f60c9b5538bed584a31455b492944007d8b1524462c";
  };

  ESPHOME_USE_SUBPROCESS = "";

  propagatedBuildInputs = with python.pkgs; [
    voluptuous pyyaml paho-mqtt colorlog
    tornado protobuf tzlocal pyserial ifaddr
  ];

  makeWrapperArgs = [
    # platformio is used in esphomeyaml/platformio_api.py
    # esptool is used in esphomeyaml/__main__.py
    # git is used in esphomeyaml/writer.py
    "--prefix PATH : ${lib.makeBinPath [ platformio esptool git ]}"
    "--set ESPHOME_USE_SUBPROCESS ''"
  ];

  # Platformio will try to access the network
  doCheck = false;

  meta = with lib; {
    description = "Make creating custom firmwares for ESP32/ESP8266 super easy";
    homepage = https://esphome.io/;
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
