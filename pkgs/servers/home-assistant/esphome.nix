{ lib, python3, platformio, esptool, git, protobuf3_7, fetchpatch }:

let
  python = python3.override {
    packageOverrides = self: super: {
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
  version = "1.13.6";

  src = python.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "53148fc43c6cc6736cb7aa4cc1189caa305812061f55289ff916f8bd731ac623";
  };

  patches = fetchpatch {
    url = https://github.com/esphome/esphome/pull/694.patch;
    includes = [ "esphome/voluptuous_schema.py" ];
    sha256 = "0i2v1d6mcgc94i9rkaqmls7iyfbaisdji41sfc7bh7cf2j824im9";
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
    maintainers = with maintainers; [ dotlambda globin ];
  };
}
