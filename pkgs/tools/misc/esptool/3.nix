{ lib, fetchFromGitHub, fetchpatch, python3, openssl }:

python3.pkgs.buildPythonApplication rec {
  pname = "esptool";
  version = "3.3.2";

  src = fetchFromGitHub {
    owner = "espressif";
    repo = "esptool";
    rev = "v${version}";
    hash = "sha256-hpPL9KNPA+S57SJoKnQewBCOybDbKep0t5RKw9a9GjM=";
  };

  patches = [
    # https://github.com/espressif/esptool/pull/802
    (fetchpatch {
      name = "bitstring-4-compatibility.patch";
      url = "https://github.com/espressif/esptool/commit/16fa58415be2a7ff059ece40d4545288565d0a23.patch";
      hash = "sha256-FYa9EvyET4P8VkdyMzJBkdxVYm0tFt2GPnfsjzBnevE=";
      excludes = [ "setup.py" ];
    })
  ];

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
    maintainers = with maintainers; [ hexa ];
    platforms = platforms.linux;
  };
}
