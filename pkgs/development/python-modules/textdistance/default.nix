{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pytestCheckHook,
  hypothesis,
  numpy,
}:

buildPythonPackage (finalAttrs: {
  pname = "textdistance";
  version = "4.6.3";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    pname = "textdistance";
    inherit (finalAttrs) version;
    hash = "sha256-1tq8ULTqgyzc8OHmAhvQx/zZreFViI15u2o8Mfzi3G8=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    pytestCheckHook
    hypothesis
    numpy
  ];

  disabledTestPaths = [ "tests/test_external.py" ];

  pythonImportsCheck = [ "textdistance" ];

  meta = {
    description = "Python library for comparing distance between two or more sequences";
    homepage = "https://github.com/life4/textdistance";
    changelog = "https://github.com/life4/textdistance/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
