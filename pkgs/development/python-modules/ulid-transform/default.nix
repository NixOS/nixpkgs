{
  lib,
  cython,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytest-benchmark,
  pytest-cov-stub,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "ulid-transform";
  version = "0.13.1";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "bdraco";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-tOtOTFKBVQmCm02k9Q8r+EgF39iN+XNXCnlw2ppYM58=";
  };

  nativeBuildInputs = [
    cython
    poetry-core
    setuptools
  ];

  nativeCheckInputs = [
    pytest-benchmark
    pytest-cov-stub
    pytestCheckHook
  ];

  pytestFlagsArray = [ "--benchmark-disable" ];

  pythonImportsCheck = [ "ulid_transform" ];

  meta = with lib; {
    description = "Library to create and transform ULIDs";
    homepage = "https://github.com/bdraco/ulid-transform";
    changelog = "https://github.com/bdraco/ulid-transform/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
