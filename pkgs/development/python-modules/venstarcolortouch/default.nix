{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  requests,
}:

buildPythonPackage (finalAttrs: {
  pname = "venstarcolortouch";
  version = "0.22";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    pname = "venstarcolortouch";
    inherit (finalAttrs) version;
    hash = "sha256-R9BJmZcseYlFLcoDUxfH3M0FO5GVsDtw7smK2dmLlNo=";
  };

  build-system = [ setuptools ];

  dependencies = [ requests ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "venstarcolortouch" ];

  meta = {
    description = "Python interface for Venstar ColorTouch thermostats Resources";
    homepage = "https://github.com/hpeyerl/venstar_colortouch";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
