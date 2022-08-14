{
  lib,
  buildPythonPackage,
  fetchPypi,
  numpy,
  setuptools-scm,
}:
buildPythonPackage rec {
  buildInputs = [setuptools-scm];
  checkInputs = [pytestCheckHook];
  pname = "tensorstore";
  propagatedBuildInputs = [numpy];
  pythonImportsCheck = ["tensorstore"];
  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-qQqytAtjXtThWh+a+dNLeQHlxYUGxdUOgK69aFDQtwA=";
  };
  version = "0.1.22";
  meta = with lib; {
    homepage = "https://google.github.io/tensorstore/";
    description = "TensorStore is a library for efficiently reading and writing large multi-dimensional arrays.";
    license = licenses.asl20;
  };
}
