{ lib, python3, platformio, esptool, git, protobuf3_10, fetchpatch }:

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
        protobuf = protobuf3_10;
      };

    };
  };

in python.pkgs.buildPythonApplication rec {
  pname = "esphome";
  version = "1.14.1";

  src = python.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "1hw1q2fck9429077w207rk65a1krzyi6qya5pzjkpw4av5s0v0g3";
  };

  ESPHOME_USE_SUBPROCESS = "";

  propagatedBuildInputs = with python.pkgs; [
    voluptuous pyyaml paho-mqtt colorlog
    tornado protobuf tzlocal pyserial ifaddr
    protobuf
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "protobuf==3.10.0" "protobuf~=3.10" \
      --replace "paho-mqtt==1.4.0" "paho-mqtt~=1.4" \
      --replace "tornado==5.1.1" "tornado~=5.1"
  '';

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
