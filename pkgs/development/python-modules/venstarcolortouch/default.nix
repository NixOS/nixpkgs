{
  lib,
  buildPythonPackage,
  fetchPypi,
  requests,
}:

buildPythonPackage rec {
  pname = "venstarcolortouch";
  version = "0.21";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-M+Sbpue6Z8+pvxzhq3teM84ect+pilwmlRe9PJYDzPU=";
  };

  propagatedBuildInputs = [ requests ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "venstarcolortouch" ];

  meta = with lib; {
    description = "Python interface for Venstar ColorTouch thermostats Resources";
    homepage = "https://github.com/hpeyerl/venstar_colortouch";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
