{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  pytest-cov-stub,
  pytest-mock,
}:

buildPythonPackage (finalAttrs: {
  pname = "ulid-py";
  version = "1.1.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "ahawker";
    repo = "ulid";
    tag = "v${finalAttrs.version}";
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
    # Benchmarks are not useful in CI and take significant time
    "tests/benchmarks/test_creation.py"
  ];

  pythonImportsCheck = [ "ulid" ];

  meta = {
    description = "Universally Unique Lexicographically Sortable Identifier (ULID) in Python 3";
    homepage = "https://github.com/ahawker/ulid";
    changelog = "https://github.com/ahawker/ulid/blob/master/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ philocalyst ];
  };
})
