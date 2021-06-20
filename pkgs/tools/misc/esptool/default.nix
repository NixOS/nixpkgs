{ lib, fetchFromGitHub, python3, openssl }:

python3.pkgs.buildPythonApplication rec {
  pname = "esptool";
  version = "3.1";

  src = fetchFromGitHub {
    owner = "espressif";
    repo = "esptool";
    rev = "v${version}";
    sha256 = "08iwcc0y1xmnqxlcc8glshv42ppj7ik2c1yyj8w9bzpzq9bsp88r";
  };

  checkInputs = with python3.pkgs;
    [ flake8 flake8-future-import flake8-import-order openssl ];
  propagatedBuildInputs = with python3.pkgs;
    [ pyserial pyaes ecdsa reedsolo bitstring cryptography ];

  # wrapPythonPrograms will overwrite esptool.py with a bash script,
  # but espefuse.py tries to import it. Since we don't add any binary paths,
  # use patchPythonScript directly.
  dontWrapPythonPrograms = true;
  postFixup = ''
    buildPythonPath "$out $pythonPath"
    for f in $out/bin/*.py; do
        echo "Patching $f"
        patchPythonScript "$f"
    done
  '';

  meta = with lib; {
    description = "ESP8266 and ESP32 serial bootloader utility";
    homepage = "https://github.com/espressif/esptool";
    license = licenses.gpl2;
    maintainers = with maintainers; [ dezgeg dotlambda ];
    platforms = platforms.linux;
  };
}
