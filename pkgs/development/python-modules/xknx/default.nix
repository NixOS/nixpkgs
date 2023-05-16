{ lib
, async-timeout
, buildPythonPackage
, fetchFromGitHub
<<<<<<< HEAD
, fetchpatch
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, cryptography
, ifaddr
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, setuptools
<<<<<<< HEAD
, wheel
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "xknx";
<<<<<<< HEAD
  version = "2.11.2";
=======
  version = "2.9.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "XKNX";
    repo = pname;
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-rKvHb0wkWVuZO8M8uIQdOiY1N6DmGSpqUgz4YYbUfSM=";
  };

  patches = [
    (fetchpatch {
      name = "unpin-setuptools.patch";
      url = "https://github.com/XKNX/xknx/commit/c0826aec52ab69b8bd81f600bea154fae16f334e.patch";
      hash = "sha256-EpfgEq4pIx7ahqJZalzo30ruj8NlZYHcKHxFXCGL98w=";
    })
  ];

  nativeBuildInputs = [
    setuptools
    wheel
=======
    hash = "sha256-1Nt69lIle4vKSXfsTKWry1DXqCBEvBJz2JOOWrUYdX4=";
  };

  nativeBuildInputs = [
    setuptools
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  propagatedBuildInputs = [
    async-timeout
    cryptography
    ifaddr
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "xknx"
  ];

  disabledTests = [
    # Test requires network access
    "test_scan_timeout"
    "test_start_secure_routing_knx_keys"
    "test_start_secure_routing_manual"
  ];

  meta = with lib; {
    description = "KNX Library Written in Python";
    longDescription = ''
      XKNX is an asynchronous Python library for reading and writing KNX/IP
      packets. It provides support for KNX/IP routing and tunneling devices.
    '';
    homepage = "https://github.com/XKNX/xknx";
    changelog = "https://github.com/XKNX/xknx/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
    platforms = platforms.linux;
  };
}
