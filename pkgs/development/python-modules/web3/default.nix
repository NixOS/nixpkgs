{ lib
, buildPythonPackage
, fetchFromGitHub
, aiohttp
, eth-abi
, eth-account
, eth-hash
, eth-typing
, eth-utils
, eth-rlp
, hexbytes
, ipfshttpclient
, jsonschema
, lru-dict
, protobuf
, requests
, typing-extensions
, websockets
# , eth-tester
# , py-geth
, pytestCheckHook
, pythonOlder
, pythonRelaxDepsHook
}:

buildPythonPackage rec {
  pname = "web3";
  version = "6.3.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "web3.py";
    rev = "v${version}";
    hash = "sha256-p3Dpmb0BST1nbh42q/eK/DjQqoIPHvNr2KllRpTgFFw=";
  };

  nativeBuildInputs = [
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = [
    aiohttp
    eth-abi
    eth-account
    eth-hash
    eth-rlp
    eth-typing
    eth-utils
    hexbytes
    ipfshttpclient
    jsonschema
    lru-dict
    protobuf
    requests
    websockets
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

  doCheck = false;

  postPatch = ''
    substituteInPlace setup.py --replace "types-protobuf==3.19.13" "types-protobuf"
  '';

  pythonImportsCheck = [
    "web3"
  ];

  meta = with lib; {
    description = "Web3 library for interactions";
    homepage = "https://github.com/ethereum/web3";
    license = licenses.mit;
    maintainers = with maintainers; [ raitobezarius ];
  };
}
