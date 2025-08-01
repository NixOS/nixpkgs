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
}:

buildPythonPackage rec {
  pname = "trie";
  version = "3.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "py-trie";
    tag = "v${version}";
    hash = "sha256-kG/5ijckiEOfB5y1c3Yqudqnb1MDbPD25YZZM+H13Lw=";
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
  ]
  ++ eth-hash.optional-dependencies.pycryptodome;

  disabledTests = [
    # some core tests require fixture submodule and execution spec
    "test_fixtures_exist"
    "test_bin_trie_update_value"
    "test_branch_updates"
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
