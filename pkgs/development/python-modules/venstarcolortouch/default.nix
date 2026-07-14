{
  lib,
  buildPythonPackage,
  fetchPypi,
  requests,
}:

buildPythonPackage (finalAttrs: {
  pname = "venstarcolortouch";
  version = "0.22";
  format = "setuptools";

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-R9BJmZcseYlFLcoDUxfH3M0FO5GVsDtw7smK2dmLlNo=";
  };

  propagatedBuildInputs = [ requests ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "venstarcolortouch" ];

  meta = {
    description = "Python interface for Venstar ColorTouch thermostats Resources";
    homepage = "https://github.com/hpeyerl/venstar_colortouch";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
})
