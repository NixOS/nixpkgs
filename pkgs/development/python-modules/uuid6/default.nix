{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pytestCheckHook,
}:
buildPythonPackage rec {
  pname = "uuid6";
  version = "2024.7.10";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-LSnX9j9ZPKruoODQ3QrYEpycZjsp4ZvfiC6GS+3xj7A=";
  };

  # https://github.com/oittaa/uuid6-python/blob/e647035428d984452b9906b75bb007198533dfb1/setup.py#L12-L19
  env.GITHUB_REF = "refs/tags/${version}";

  build-system = [
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "test/"
  ];

  disabledTestPaths = [
    "test/test_uuid6.py"
  ];

  pythonImportsCheck = [
    "uuid6"
  ];

  meta = {
    description = "New time-based UUID formats which are suited for use as a database key";
    homepage = "https://github.com/oittaa/uuid6-python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ aleksana ];
  };
}
