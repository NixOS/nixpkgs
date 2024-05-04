{ lib
, buildPythonPackage
, fetchPypi
, requests
, setuptools
}:

buildPythonPackage rec {
  pname = "zephyr-python-api";
  version = "0.0.5";
  format = "pyproject";

  src = fetchPypi {
    pname = "zephyr_python_api";
    inherit version;
    hash = "sha256-tzuLFM2Oav5rKH1GEZcP/Kfw4NXRTObMf1gcn862UBw=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    requests
  ];

  # No tests in archive
  doCheck = false;

  pythonImportsCheck = [ "zephyr" ];

  meta = {
    homepage = "https://github.com/nassauwinter/zephyr-python-api";
    description = "A set of wrappers for Zephyr Scale (TM4J) REST API";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ rapiteanu ];
  };
}
