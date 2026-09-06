{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,

  # build-system
  setuptools,

  # dependencies
  aiohttp,
  eth-abi,
  eth-account,
  eth-hash,
  eth-typing,
  eth-utils,
  hexbytes,
  jsonschema,
  lru-dict,
  protobuf,
  pydantic,
  requests,
  types-requests,
  websockets,

  # optional-dependencies
  ipfshttpclient,

  # tests
  eth-tester,
  flaky,
  hypothesis,
  py-evm,
  pytest-asyncio,
  pytest-mock,
  pytest-xdist,
  pytestCheckHook,
  pyunormalize,
}:

buildPythonPackage rec {
  pname = "web3";
  version = "7.16.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "web3.py";
    tag = "v${version}";
    hash = "sha256-Dgkmmx4gmVJa4P26X1waaQaKc75COC17OSeJz43EZZ0=";
  };

  patches = [
    # fix Python 3.14, avoid copying itertools.count, which is no longer supported
    # https://github.com/ethereum/web3.py/pull/3779
    (fetchpatch {
      url = "https://github.com/ethereum/web3.py/commit/9923ee46cab6a49af4d7bdb3f922c4f8d9670633.patch";
      includes = [ "web3/_utils/module_testing/utils.py" ];
      hash = "sha256-N6v3QVDN0fCEWqs34uZ+B18+WXOPoY+Lyk9rIM+btjk=";
    })
  ];

  build-system = [ setuptools ];

  pythonRelaxDeps = [
    "websockets"
  ];

  dependencies = [
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

  # Note: to reflect the extra_requires in main/setup.py.
  optional-dependencies = {
    ipfs = [ ipfshttpclient ];
  };

  nativeCheckInputs = [
    eth-tester
    flaky
    hypothesis
    py-evm
    pytest-asyncio
    pytest-mock
    pytest-xdist
    pytestCheckHook
    pyunormalize
  ];

  disabledTests = [
    # side-effect: runs pip online check and is blocked by sandbox
    "test_install_local_wheel"

    # not sure why they fail
    "test_async_init_multiple_contracts_performance"
    "test_init_multiple_contracts_performance"

    # AssertionError: assert '/build/geth.ipc' == '/tmp/geth.ipc
    "test_get_dev_ipc_path"

    # Require network access
    "test_websocket_provider_timeout"
  ];

  disabledTestPaths = [
    # requires geth library and binaries
    "tests/integration/go_ethereum"

    # requires local running beacon node
    "tests/beacon"
  ];

  pythonImportsCheck = [ "web3" ];

  meta = {
    description = "Python interface for interacting with the Ethereum blockchain and ecosystem";
    homepage = "https://web3py.readthedocs.io/";
    changelog = "https://web3py.readthedocs.io/en/stable/release_notes.html";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hellwolf ];
  };
}
