{ lib
, fetchFromGitHub
, python3
<<<<<<< HEAD
, softhsm
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

python3.pkgs.buildPythonApplication rec {
  pname = "esptool";
<<<<<<< HEAD
  version = "4.6.2";

  format = "setuptools";
=======
  version = "4.5.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "espressif";
    repo = "esptool";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-3uvTyJrGCpulu/MR/VfCgnIxibxJj2ehBIBSveq7EfI=";
  };

  postPatch = ''
    patchShebangs ci

    substituteInPlace test/test_espsecure_hsm.py \
      --replace "/usr/lib/softhsm" "${lib.getLib softhsm}/lib/softhsm"
  '';

=======
    hash = "sha256-FKFw7czXzC8F3OXjlLoJEFaqsSgqWz0ZEqd7KjCy5Ik=";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  propagatedBuildInputs = with python3.pkgs; [
    bitstring
    cryptography
    ecdsa
    pyserial
    reedsolo
<<<<<<< HEAD
    pyyaml
    python-pkcs11
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  nativeCheckInputs = with python3.pkgs; [
    pyelftools
    pytestCheckHook
<<<<<<< HEAD
    softhsm
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  # tests mentioned in `.github/workflows/test_esptool.yml`
  checkPhase = ''
    runHook preCheck

<<<<<<< HEAD
    export SOFTHSM2_CONF=$(mktemp)
    echo "directories.tokendir = $(mktemp -d)" > "$SOFTHSM2_CONF"
    ./ci/setup_softhsm2.sh

    pytest test/test_imagegen.py
    pytest test/test_espsecure.py
    pytest test/test_espsecure_hsm.py
=======
    pytest test/test_imagegen.py
    pytest test/test_espsecure.py
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    mainProgram = "esptool.py";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
