{
  lib,
  cython,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytest-benchmark,
  pytest-codspeed,
  pytest-cov-stub,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "ulid-transform";
  version = "1.5.2";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "bdraco";
    repo = "ulid-transform";
    tag = "v${version}";
    hash = "sha256-S9+vP0frNvA4wWZMyLPYq6L/5PmLcyFNdN8NY+IrlzQ=";
  };

  build-system = [
    cython
    poetry-core
    setuptools
  ];

  nativeCheckInputs = [
    pytest-benchmark
    pytest-codspeed
    pytest-cov-stub
    pytestCheckHook
  ];

  pytestFlags = [ "--benchmark-disable" ];

  pythonImportsCheck = [ "ulid_transform" ];

  meta = with lib; {
    description = "Library to create and transform ULIDs";
    homepage = "https://github.com/bdraco/ulid-transform";
    changelog = "https://github.com/bdraco/ulid-transform/blob/${src.tag}/CHANGELOG.md";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
