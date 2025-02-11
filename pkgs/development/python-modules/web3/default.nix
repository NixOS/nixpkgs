{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  # dependencies
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
  pydantic,
  requests,
  types-requests,
  websockets,
  # nativeCheckInputs
  eth-tester,
  flaky,
  hypothesis,
  py-evm,
  pytest-asyncio_0_21,
  pytestCheckHook,
  pytest-mock,
  pytest-xdist,
  pyunormalize,
}:

buildPythonPackage rec {
  pname = "web3";
  version = "7.6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "web3.py";
    tag = "v${version}";
    hash = "sha256-rpXSkQtqUZiCLMF2XlElbsjFjJmX+3j/NdAU2oaPU54=";
  };

  # Note: to reflect the extra_requires in main/setup.py.
  optional-dependencies = {
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
    eth-tester
    flaky
    hypothesis
    py-evm
    pytest-asyncio_0_21
    pytestCheckHook
    pytest-mock
    pytest-xdist
    pyunormalize
  ];

  disabledTests = [
    # side-effect: runs pip online check and is blocked by sandbox
    "test_install_local_wheel"
    # not sure why they fail
    "test_init_multiple_contracts_performance"
    "test_async_init_multiple_contracts_performance"
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
