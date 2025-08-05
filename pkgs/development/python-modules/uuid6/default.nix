{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pytestCheckHook,
}:
buildPythonPackage rec {
  pname = "uuid6";
  version = "2025.0.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-zQr5T6QoZ1pE4yxTGexaNIUiW6IXnu/PTD8gWuMKgb0=";
  };

  # https://github.com/oittaa/uuid6-python/blob/e647035428d984452b9906b75bb007198533dfb1/setup.py#L12-L19
  env.GITHUB_REF = "refs/tags/${version}";

  build-system = [
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  enabledTestPaths = [
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
