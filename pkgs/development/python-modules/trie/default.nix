{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  eth-hash,
  eth-utils,
  hexbytes,
  hypothesis,
  pytestCheckHook,
  pytest-xdist,
  rlp,
  setuptools,
  sortedcontainers,
}:

buildPythonPackage rec {
  pname = "trie";
  version = "3.0.1";

  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "py-trie";
    rev = "refs/tags/v${version}";
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
  ] ++ eth-hash.optional-dependencies.pycryptodome;

  # some core tests require fixture submodule and execution spec
  disabledTests = [ "test_fixtures_exist" ];
  disabledTestPaths = [ "tests/core/test_iter.py" ];

  pythonImportsCheck = [ "trie" ];

  meta = with lib; {
    description = "Python library which implements the Ethereum Trie structure";
    homepage = "https://github.com/ethereum/py-trie";
    license = licenses.mit;
    maintainers = [ ];
  };
}
