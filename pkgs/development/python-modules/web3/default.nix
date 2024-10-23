{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  aiohttp,
  eth-abi,
  eth-account,
  eth-hash,
  eth-typing,
  eth-utils,
  hexbytes,
  ipfshttpclient,
  jsonschema,
  lru-dict,
  protobuf,
  requests,
  websockets,
  pyunormalize,
}:

buildPythonPackage rec {
  pname = "web3";
  version = "6.20.3";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "web3.py";
    rev = "v${version}";
    hash = "sha256-lxCd1Cc79SW8uQrKom9Lqeb7VPuj2nKFlCj51EgSSuk=";
  };

  # Note: to reflect the extra_requires in main/setup.py.
  optional-dependencies = {
    ipfs = [ ipfshttpclient ];
  };

  dependencies = [
    aiohttp
    eth-abi
    eth-account
    eth-hash
    eth-typing
    eth-utils
    hexbytes
    jsonschema
    lru-dict
    protobuf
    requests
    websockets
    pyunormalize
  ] ++ eth-hash.optional-dependencies.pycryptodome;

  # TODO: package eth-tester required for tests
  doCheck = false;

  postPatch = ''
    substituteInPlace setup.py --replace "types-protobuf==3.19.13" "types-protobuf"
  '';

  pythonImportsCheck = [ "web3" ];

  meta = with lib; {
    description = "Python interface for interacting with the Ethereum blockchain and ecosystem";
    homepage = "https://web3py.readthedocs.io/";
    license = licenses.mit;
    maintainers = with maintainers; [ hellwolf ];
  };
}
