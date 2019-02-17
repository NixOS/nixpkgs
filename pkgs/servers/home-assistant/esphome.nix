{ lib, python3, fetchpatch, substituteAll, platformio, esptool }:

python3.pkgs.buildPythonApplication rec {
  pname = "esphomeyaml";
  version = "1.10.1";

  src = python3.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "426cd545b4e9505ce5b4f5c63d2d54cb038f93fe3ba9d4d56b6b6431b222485d";
  };

  patches = [
    (substituteAll {
      src = ./dont-import-platformio-esptool.patch;
      inherit platformio esptool;
    })
  ];

  postPatch = ''
     # typing is part of the standard library since Python 3.5
     substituteInPlace setup.py --replace "'typing>=3.0.0'," ""
  '';

  propagatedBuildInputs = with python3.pkgs; [
    voluptuous pyyaml paho-mqtt colorlog
    tornado protobuf tzlocal pyserial
  ];

  checkPhase = ''
    $out/bin/esphomeyaml tests/test1.yaml compile
    $out/bin/esphomeyaml tests/test2.yaml compile
  '';

  # Platformio will try to access the network
  doCheck = false;

  meta = with lib; {
    description = "Make creating custom firmwares for ESP32/ESP8266 super easy";
    homepage = https://esphomelib.com/esphomeyaml;
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
