{ lib, fetchFromGitHub, python3, openssl }:

python3.pkgs.buildPythonApplication rec {
  pname = "esptool";
  version = "3.3.1";

  src = fetchFromGitHub {
    owner = "espressif";
    repo = "esptool";
    rev = "v${version}";
    hash = "sha256-9WmiLji7Zoad5WIzgkpvkI9t96sfdkCtFh6zqVxF7qo=";
  };

  postPatch = ''
    substituteInPlace test/test_imagegen.py \
      --replace "sys.executable, ESPTOOL_PY" "ESPTOOL_PY"
  '';

  propagatedBuildInputs = with python3.pkgs; [
    bitstring
    cryptography
    ecdsa
    pyserial
    reedsolo
  ];

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

  checkInputs = with python3.pkgs; [
    pyelftools
  ];

  # tests mentioned in `.github/workflows/test_esptool.yml`
  checkPhase = ''
    runHook preCheck

    export ESPTOOL_PY=$out/bin/esptool.py
    ${python3.interpreter} test/test_imagegen.py
    ${python3.interpreter} test/test_espsecure.py
    ${python3.interpreter} test/test_merge_bin.py
    ${python3.interpreter} test/test_modules.py

    runHook postCheck
  '';

  meta = with lib; {
    description = "ESP8266 and ESP32 serial bootloader utility";
    homepage = "https://github.com/espressif/esptool";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ dezgeg dotlambda ] ++ teams.lumiguide.members;
    platforms = with platforms; linux ++ darwin;
  };
}
