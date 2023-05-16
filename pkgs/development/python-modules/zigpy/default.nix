{ lib
, aiohttp
, aiosqlite
, buildPythonPackage
, crccheck
, cryptography
, freezegun
, fetchFromGitHub
, pycryptodome
, pyserial-asyncio
, pytest-asyncio
, pytest-timeout
, pytestCheckHook
, pythonOlder
<<<<<<< HEAD
, setuptools
, voluptuous
, wheel
=======
, voluptuous
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "zigpy";
<<<<<<< HEAD
  version = "0.57.1";
  format = "pyproject";
=======
  version = "0.55.0";
  format = "setuptools";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "zigpy";
    repo = "zigpy";
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-aVrLiWPjc4xn2GvKmZCrRJGGbxP545PKqAH9rPq8IPo=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace '"setuptools-git-versioning<2"' "" \
      --replace 'dynamic = ["version"]' 'version = "${version}"'
  '';

  nativeBuildInputs = [
    setuptools
    wheel
  ];

=======
    hash = "sha256-fc98V6KJ7zROgNktHZlWj9/BQRbCIWYT5Px09mFrwHQ=";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  propagatedBuildInputs = [
    aiohttp
    aiosqlite
    crccheck
    cryptography
    pyserial-asyncio
    pycryptodome
    voluptuous
  ];

  nativeCheckInputs = [
    freezegun
    pytest-asyncio
    pytest-timeout
    pytestCheckHook
  ];

  disabledTests = [
    # # Our two manual scans succeeded and the periodic one was attempted
    # assert len(mock_scan.mock_calls) == 3
    # AssertionError: assert 4 == 3
    "test_periodic_scan_priority"
  ];

  pythonImportsCheck = [
    "zigpy.application"
    "zigpy.config"
    "zigpy.exceptions"
    "zigpy.types"
    "zigpy.zcl"
  ];

  meta = with lib; {
    description = "Library implementing a ZigBee stack";
    homepage = "https://github.com/zigpy/zigpy";
    changelog = "https://github.com/zigpy/zigpy/releases/tag/${version}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ mvnetbiz ];
    platforms = platforms.linux;
  };
}
