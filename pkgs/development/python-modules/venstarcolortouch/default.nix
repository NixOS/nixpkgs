{
  lib,
  buildPythonPackage,
  fetchPypi,
  requests,
}:

buildPythonPackage rec {
  pname = "venstarcolortouch";
  version = "0.20";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-HX1GPhLksD7T0jbnGxk85CgF8bnPXWrUnbOgCKsmeT0=";
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
