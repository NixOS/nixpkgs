{ lib, python3, platformio, esptool, git, protobuf3_11, fetchpatch }:

let
  python = python3.override {
    packageOverrides = self: super: {
      protobuf = super.protobuf.override {
        protobuf = protobuf3_11;
      };
    };
  };

in python.pkgs.buildPythonApplication rec {
  pname = "esphome";
  version = "1.14.5";

  src = python.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "176mi361677d5cqbi0hn52kky845byjs6gdad8pdhihyjgv7a9y9";
  };

  ESPHOME_USE_SUBPROCESS = "";

  propagatedBuildInputs = with python.pkgs; [
    voluptuous pyyaml paho-mqtt colorlog
    tornado protobuf tzlocal pyserial ifaddr
    protobuf click
  ];

  # remove all version pinning (E.g tornado==5.1.1 -> tornado)
  postPatch = ''
    sed -i -e "s/==[0-9.]*//" setup.py
  '';

  makeWrapperArgs = [
    # platformio is used in esphomeyaml/platformio_api.py
    # esptool is used in esphomeyaml/__main__.py
    # git is used in esphomeyaml/writer.py
    "--prefix PATH : ${lib.makeBinPath [ platformio esptool git ]}"
    "--set ESPHOME_USE_SUBPROCESS ''"
  ];

  # Platformio will try to access the network
  # Instead, run the executable
  checkPhase = ''
    $out/bin/esphome --help > /dev/null
  '';

  meta = with lib; {
    description = "Make creating custom firmwares for ESP32/ESP8266 super easy";
    homepage = "https://esphome.io/";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda globin ];
  };
}
