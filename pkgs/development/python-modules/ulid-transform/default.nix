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
  setuptools,
}:

buildPythonPackage rec {
  pname = "ulid-transform";
  version = "1.5.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Bluetooth-Devices";
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

  meta = {
    description = "Library to create and transform ULIDs";
    homepage = "https://github.com/Bluetooth-Devices/ulid-transform";
    changelog = "https://github.com/Bluetooth-Devices/ulid-transform/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
