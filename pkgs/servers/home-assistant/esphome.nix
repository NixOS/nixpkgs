{ lib, python3, platformio, esptool, git, protobuf3_10, fetchpatch }:

let
  python = python3.override {
    packageOverrides = self: super: {
      protobuf = super.protobuf.override {
        protobuf = protobuf3_10;
      };
      pyyaml = super.pyyaml.overridePythonAttrs (oldAttrs: rec {
        version = "5.1.2";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "1r5faspz73477hlbjgilw05xsms0glmsa371yqdd26znqsvg1b81";
        };
      });
    };
  };

in python.pkgs.buildPythonApplication rec {
  pname = "esphome";
  version = "1.14.3";

  src = python.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "0xnsl000c5a2li9qw9anrzzq437qn1n4hcfc24i4rfq37awzmig7";
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
