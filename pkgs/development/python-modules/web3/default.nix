{ lib
, buildPythonPackage
, fetchFromGitHub
<<<<<<< HEAD
, pythonOlder
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, aiohttp
, eth-abi
, eth-account
, eth-hash
, eth-typing
, eth-utils
<<<<<<< HEAD
=======
, eth-rlp
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, hexbytes
, ipfshttpclient
, jsonschema
, lru-dict
, protobuf
, requests
<<<<<<< HEAD
, websockets
=======
, typing-extensions
, websockets
# , eth-tester
# , py-geth
, pytestCheckHook
, pythonOlder
, pythonRelaxDepsHook
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "web3";
<<<<<<< HEAD
  version = "6.5.0";
=======
  version = "6.3.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "web3.py";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-RNWCZQjcse415SSNkHhMWckDcBJGFZnjisckF7gbYY8=";
  };

  # Note: to reflect the extra_requires in main/setup.py.
  passthru.optional-dependencies = {
    ipfs = [ ipfshttpclient ];
  };
=======
    hash = "sha256-p3Dpmb0BST1nbh42q/eK/DjQqoIPHvNr2KllRpTgFFw=";
  };

  nativeBuildInputs = [
    pythonRelaxDepsHook
  ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  propagatedBuildInputs = [
    aiohttp
    eth-abi
    eth-account
<<<<<<< HEAD
    eth-hash ] ++ eth-hash.optional-dependencies.pycryptodome ++ [
    eth-typing
    eth-utils
    hexbytes
=======
    eth-hash
    eth-rlp
    eth-typing
    eth-utils
    hexbytes
    ipfshttpclient
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    jsonschema
    lru-dict
    protobuf
    requests
    websockets
<<<<<<< HEAD
  ];

  # TODO: package eth-tester required for tests
=======
  ] ++ lib.optionals (pythonOlder "3.8") [
    typing-extensions
  ] ++ eth-hash.optional-dependencies.pycryptodome;

  pythonRelaxDeps = true;

  # TODO: package eth-tester
  #nativeCheckInputs = [
  #  eth-tester
  #  eth-tester.optional-dependencies.py-evm
  #  py-geth
  #  pytestCheckHook
  #];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  doCheck = false;

  postPatch = ''
    substituteInPlace setup.py --replace "types-protobuf==3.19.13" "types-protobuf"
  '';

  pythonImportsCheck = [
    "web3"
  ];

  meta = with lib; {
<<<<<<< HEAD
    description = "A python interface for interacting with the Ethereum blockchain and ecosystem";
    homepage = "https://web3py.readthedocs.io/";
    license = licenses.mit;
    maintainers = with maintainers; [ hellwolf ];
=======
    description = "Web3 library for interactions";
    homepage = "https://github.com/ethereum/web3";
    license = licenses.mit;
    maintainers = with maintainers; [ raitobezarius ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
