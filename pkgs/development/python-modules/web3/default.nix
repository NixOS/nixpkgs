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
}:

buildPythonPackage rec {
  pname = "web3";
  version = "5.30.0";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "web3.py";
    rev = "v${version}";
    sha256 = "sha256-HajumvOG18r7TslkmCfI0iiLsEddevGrRZQFWICGeYE=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "eth-account>=0.5.7,<0.6.0" "eth-account>=0.5.7,<0.7" \
      --replace "eth-utils>=1.9.5,<2.0.0" "eth-utils>=1.9.5,<3" \
      --replace "eth-rlp<0.3" "eth-rlp<0.4" \
      --replace "websockets>=9.1,<10" "websockets>=9.1,<11" \
      --replace "eth-abi>=2.0.0b6,<3.0.0" "eth-abi>=2.0.0b6,<4" \
      --replace "eth-typing>=2.0.0,<3.0.0" "eth-typing>=2.0.0,<4"
  '';

  propagatedBuildInputs = [
    aiohttp
    eth-abi
    eth-account
    eth-hash
    eth-hash.optional-dependencies.pycryptodome
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
  ] ++ lib.optional (pythonOlder "3.8") [ typing-extensions ];

  # TODO: package eth-tester
  #checkInputs = [
  #  eth-tester
  #  eth-tester.optional-dependencies.py-evm
  #  py-geth
  #  pytestCheckHook
  #];

  doCheck = false;

  pythonImportsCheck = [ "web3" ];

  meta = with lib; {
    description = "Web3 library for interactions";
    homepage = "https://github.com/ethereum/web3";
    license = licenses.mit;
    maintainers = with maintainers; [ raitobezarius ];
  };
}
