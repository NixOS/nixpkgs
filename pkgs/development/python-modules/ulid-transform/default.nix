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
  version = "1.2.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "bdraco";
    repo = "ulid-transform";
    tag = "v${version}";
    hash = "sha256-+P5sd3FSk9SYmeHkatB88EE+/1vktyiJJeaecbBkBhI=";
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

  pytestFlagsArray = [ "--benchmark-disable" ];

  pythonImportsCheck = [ "ulid_transform" ];

  meta = with lib; {
    description = "Library to create and transform ULIDs";
    homepage = "https://github.com/bdraco/ulid-transform";
    changelog = "https://github.com/bdraco/ulid-transform/blob/${src.tag}/CHANGELOG.md";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
