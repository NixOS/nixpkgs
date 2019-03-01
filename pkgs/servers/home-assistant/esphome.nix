{ lib, python3, fetchpatch, platformio, esptool, git }:

python3.pkgs.buildPythonApplication rec {
  pname = "esphome";
  version = "1.11.2";

  src = python3.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "0kg8fqv3mv8i852jr42p4mipa9wjlzjwj60j1r2zpgzgr8p8wfs8";
  };

  ESPHOME_USE_SUBPROCESS = "";

  propagatedBuildInputs = with python3.pkgs; [
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

  checkPhase = ''
    $out/bin/esphomeyaml tests/test1.yaml compile
    $out/bin/esphomeyaml tests/test2.yaml compile
  '';

  # Platformio will try to access the network
  doCheck = false;

  meta = with lib; {
    description = "Make creating custom firmwares for ESP32/ESP8266 super easy";
    homepage = https://esphome.io/;
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
