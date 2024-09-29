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
}:

buildPythonPackage rec {
  pname = "web3";
  version = "6.5.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "web3.py";
    rev = "v${version}";
    hash = "sha256-RNWCZQjcse415SSNkHhMWckDcBJGFZnjisckF7gbYY8=";
  };

  # Note: to reflect the extra_requires in main/setup.py.
  optional-dependencies = {
    ipfs = [ ipfshttpclient ];
  };

  propagatedBuildInputs =
    [
      aiohttp
      eth-abi
      eth-account
      eth-hash
    ]
    ++ eth-hash.optional-dependencies.pycryptodome
    ++ [
      eth-typing
      eth-utils
      hexbytes
      jsonschema
      lru-dict
      protobuf
      requests
      websockets
    ];

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
