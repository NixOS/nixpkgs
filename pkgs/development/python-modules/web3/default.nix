{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  aiohttp,
  eth-abi,
  eth-account,
  eth-hash,
  eth-tester,
  eth-typing,
  eth-utils,
  flaky,
  hexbytes,
  hypothesis,
  ipfshttpclient,
  jsonschema,
  lru-dict,
  protobuf,
  pydantic,
  pytestCheckHook,
  pytest-asyncio_0_21,
  pytest-mock,
  pytest-xdist,
  pyunormalize,
  py-evm,
  requests,
  setuptools,
  types-requests,
  websockets,
}:

buildPythonPackage rec {
  pname = "web3";
  version = "7.2.0";

  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "web3.py";
    rev = "refs/tags/v${version}";
    hash = "sha256-CMzcVlQKZ/ooWyYriRb/cTBE//Dkkgkn0gu0Y4ZMSrQ=";
  };

  # Note: to reflect the extra_requires in main/setup.py.
  passthru.optional-dependencies = {
    ipfs = [ ipfshttpclient ];
  };

  build-system = [ setuptools ];

  dependencies =
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
      pydantic
      requests
      types-requests
      websockets
    ];

  nativeCheckInputs = [
    pytestCheckHook
    eth-tester
    flaky
    hypothesis
    pytest-asyncio_0_21
    pytest-mock
    pytest-xdist
    pyunormalize
    py-evm
  ];

  disabledTests = [
    # side-effect: runs pip online check and is blocked by sandbox
    "test_install_local_wheel"
  ];

  disabledTestPaths = [
    # requires geth library and binaries
    "tests/integration/go_ethereum"
    # requires local running beacon node
    "tests/beacon"
  ];

  pythonImportsCheck = [ "web3" ];

  meta = with lib; {
    description = "Python interface for interacting with the Ethereum blockchain and ecosystem";
    homepage = "https://web3py.readthedocs.io/";
    license = licenses.mit;
    maintainers = with maintainers; [ hellwolf ];
  };
}
