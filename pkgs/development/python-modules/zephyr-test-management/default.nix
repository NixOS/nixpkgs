{
  lib,
  buildPythonPackage,
  fetchPypi,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "zephyr-test-management";
  version = "0.2.1";
  pyproject = true;

  src = fetchPypi {
    pname = "zephyr_test_management";
    inherit version;
    hash = "sha256-bzRtiDoNbMfUKeHgVVomcX+RHaY2D0gAsWFuGahykVE=";
  };

  build-system = [ setuptools ];

  dependencies = [ requests ];

  # No tests in archive
  doCheck = false;

  pythonImportsCheck = [ "zephyr" ];

  meta = {
    homepage = "https://github.com/Steinhagen/zephyr-test-management";
    description = "Wrappers for both Zephyr Scale and Zephyr Squad (TM4J) REST APIs";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ rapiteanu ];
  };
}
