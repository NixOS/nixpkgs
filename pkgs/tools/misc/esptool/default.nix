{ lib
, fetchFromGitHub
, fetchpatch
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "esptool";
  version = "4.4";

  src = fetchFromGitHub {
    owner = "espressif";
    repo = "esptool";
    rev = "v${version}";
    hash = "sha256-haLwf3loOvqdqQN/iuVBciQ6nCnuc9AqqOGKvDwLBHE=";
  };

  patches = [
    ./test-call-bin-directly.patch
    (fetchpatch {
      name = "bitstring-4-compatibility.patch";
      url = "https://github.com/espressif/esptool/commit/ee27a6437576797d5f58c31e1c39f3a232a71df0.patch";
      hash = "sha256-8/AzR3HK79eQQRSaGEKU4YKn/piPCPjm/G9pvizKuUE=";
    })
  ];

  propagatedBuildInputs = with python3.pkgs; [
    bitstring
    cryptography
    ecdsa
    pyserial
    reedsolo
  ];

  nativeCheckInputs = with python3.pkgs; [
    pyelftools
    pytest
  ];

  # tests mentioned in `.github/workflows/test_esptool.yml`
  checkPhase = ''
    runHook preCheck

    export ESPSECURE_PY=$out/bin/espsecure.py
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
    platforms = platforms.linux;
  };
}
