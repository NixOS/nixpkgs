{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  requests,
  paho-mqtt,
  cryptography,
}:
let
  pname = "tuya-device-sharing-sdk";
<<<<<<< HEAD
  version = "0.2.7";
=======
  version = "0.2.5";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
in
buildPythonPackage {
  inherit pname version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tuya";
    repo = "tuya-device-sharing-sdk";
    # no tags on GitHub: https://github.com/tuya/tuya-device-sharing-sdk/issues/2
    # no sdist on PyPI: https://github.com/tuya/tuya-device-sharing-sdk/issues/41
<<<<<<< HEAD
    # check the dev branch for new changes
    rev = "86c0510e7229b9cf41b2bae57f3557a4d83c1928";
    hash = "sha256-nL7lr6HC+YpvmAdTnR6hzzn+9MEgzHkyzZuwjzsFHV0=";
=======
    rev = "b2156585daefa39fcd2feff964e9be53124697f1";
    hash = "sha256-ypAS8tzO4Wyc8pVjSiGaNNl+2fkFNcC3Ftql3l2B8k8=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ setuptools ];

  dependencies = [
    requests
    paho-mqtt
    cryptography
  ];

  doCheck = false; # no tests

<<<<<<< HEAD
  meta = {
    description = "Tuya Device Sharing SDK";
    homepage = "https://github.com/tuya/tuya-device-sharing-sdk";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ aciceri ];
=======
  meta = with lib; {
    description = "Tuya Device Sharing SDK";
    homepage = "https://github.com/tuya/tuya-device-sharing-sdk";
    license = licenses.mit;
    maintainers = with maintainers; [ aciceri ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
