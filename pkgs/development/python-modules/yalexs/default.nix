{ lib
, aiofiles
, aiohttp
, aioresponses
, aiounittest
, buildPythonPackage
<<<<<<< HEAD
, ciso8601
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, fetchFromGitHub
, pubnub
, pyjwt
, pytestCheckHook
, python-dateutil
, pythonOlder
, requests
, requests-mock
}:

buildPythonPackage rec {
  pname = "yalexs";
<<<<<<< HEAD
  version = "1.9.0";
=======
  version = "1.3.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "bdraco";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-9rXAFMFpKF+oIKXSFLVCLDfdpMF837xRIEe3aH7ditc=";
=======
    hash = "sha256-dUiaz1adXsiVji1YZYkYN6NCFGzAWIBPjVTeyvUaiqU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    aiofiles
    aiohttp
<<<<<<< HEAD
    ciso8601
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    pubnub
    pyjwt
    python-dateutil
    requests
  ];

  nativeCheckInputs = [
    aioresponses
    aiounittest
    pytestCheckHook
    requests-mock
  ];

  postPatch = ''
    # Not used requirement
    substituteInPlace setup.py \
      --replace '"vol",' ""
  '';

  pythonImportsCheck = [
    "yalexs"
  ];

  meta = with lib; {
    description = "Python API for Yale Access (formerly August) Smart Lock and Doorbell";
    homepage = "https://github.com/bdraco/yalexs";
    changelog = "https://github.com/bdraco/yalexs/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
