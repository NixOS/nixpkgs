{ lib
, fetchFromGitHub
, python3
, softhsm
}:

python3.pkgs.buildPythonApplication rec {
  pname = "esptool";
  version = "4.6.2";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "espressif";
    repo = "esptool";
    rev = "v${version}";
    hash = "sha256-3uvTyJrGCpulu/MR/VfCgnIxibxJj2ehBIBSveq7EfI=";
  };

  postPatch = ''
    patchShebangs ci

    substituteInPlace test/test_espsecure_hsm.py \
      --replace "/usr/lib/softhsm" "${lib.getLib softhsm}/lib/softhsm"
  '';

  propagatedBuildInputs = with python3.pkgs; [
    bitstring
    cryptography
    ecdsa
    pyserial
    reedsolo
    pyyaml
    python-pkcs11
  ];

  nativeCheckInputs = with python3.pkgs; [
    pyelftools
    pytestCheckHook
    softhsm
  ];

  # tests mentioned in `.github/workflows/test_esptool.yml`
  checkPhase = ''
    runHook preCheck

    export SOFTHSM2_CONF=$(mktemp)
    echo "directories.tokendir = $(mktemp -d)" > "$SOFTHSM2_CONF"
    ./ci/setup_softhsm2.sh

    pytest test/test_imagegen.py
    pytest test/test_espsecure.py
    pytest test/test_espsecure_hsm.py
    pytest test/test_merge_bin.py
    pytest test/test_image_info.py
    pytest test/test_modules.py

    runHook postCheck
  '';

  meta = with lib; {
    description = "ESP8266 and ESP32 serial bootloader utility";
    homepage = "https://github.com/espressif/esptool";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ dezgeg dotlambda ] ++ teams.lumiguide.members;
    platforms = with platforms; linux ++ darwin;
    mainProgram = "esptool.py";
  };
}
