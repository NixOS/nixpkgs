{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  pytest-cov-stub,
  pytest-mock,
}:

buildPythonPackage rec {
  pname = "ulid-py";
  version = "1.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ahawker";
    repo = "ulid";
    rev = "refs/tags/v${version}";
    hash = "sha256-A+Pc1fkjez6FWqj5L84115GDkeDwGKQ9GbIB95MPSlY=";
  };

  build-system = [
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
    pytest-mock
  ];

  disabledTestPaths = [
    # We don't need to benchmark the library
    "tests/benchmarks/test_creation.py"
  ];

  pythonImportsCheck = [ "ulid" ];

  meta = {
    description = "Universally Unique Lexicographically Sortable Identifier (ULID) in Python 3";
    homepage = "https://github.com/ahawker/ulid";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
}
