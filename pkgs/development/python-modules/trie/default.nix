{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  # dependencies
  eth-hash,
  eth-utils,
  hexbytes,
  rlp,
  sortedcontainers,
  # nativeCheckInputs
  hypothesis,
  pytestCheckHook,
  pytest-xdist,
  pydantic,
}:

buildPythonPackage rec {
  pname = "trie";
  version = "3.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "py-trie";
    tag = "v${version}";
    hash = "sha256-QDywlAyFbQGgkATVifdixlnob4Tmsvr/VZ1rafzWKrU=";
  };

  build-system = [ setuptools ];

  dependencies = [
    eth-hash
    eth-utils
    hexbytes
    rlp
    sortedcontainers
  ];

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
    pytest-xdist
    pydantic
  ]
  ++ eth-hash.optional-dependencies.pycryptodome;

  disabledTests = [
    # some core tests require fixture submodule and execution spec
    "test_fixtures_exist"
    "test_bin_trie_update_value"
    "test_branch_updates"
    "test_install_local_wheel"
  ];
  disabledTestPaths = [ "tests/core/test_iter.py" ];

  pythonImportsCheck = [ "trie" ];

  meta = {
    description = "Python library which implements the Ethereum Trie structure";
    homepage = "https://github.com/ethereum/py-trie";
    changelog = "https://github.com/ethereum/py-trie/blob/v${version}/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hellwolf ];
  };
}
