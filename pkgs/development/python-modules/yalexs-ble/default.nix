{ lib
<<<<<<< HEAD
, async-interrupt
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, async-timeout
, bleak
, bleak-retry-connector
, buildPythonPackage
, cryptography
, fetchFromGitHub
, lru-dict
, poetry-core
, pytest-asyncio
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "yalexs-ble";
<<<<<<< HEAD
  version = "2.3.0";
=======
  version = "2.1.16";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "bdraco";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-QL8S5fDNi6msyaV14E6tgN0C/nvXqV0+Mx+4AY0um4o=";
=======
    hash = "sha256-dA0g5HAvbnN1t2D+JTfphxZUEbUT7NBLY6oCKFNf5E8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
<<<<<<< HEAD
    async-interrupt
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    async-timeout
    bleak
    bleak-retry-connector
    cryptography
    lru-dict
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace " --cov=yalexs_ble --cov-report=term-missing:skip-covered" ""
  '';

  pythonImportsCheck = [
    "yalexs_ble"
  ];

  meta = with lib; {
    description = "Library for Yale BLE devices";
    homepage = "https://github.com/bdraco/yalexs-ble";
    changelog = "https://github.com/bdraco/yalexs-ble/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ fab ];
  };
}
