{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "x256";
  version = "0.0.3";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-+FXbzNkeU/WJAoPYIDhVdDgn5+7VldXPGVRLo9IS4AE=";
  };

  build-system = [ setuptools ];

  doCheck = false;

  pythonImportsCheck = [ "x256" ];

  meta = {
    description = "Find the nearest xterm 256 color index for an RGB";
    homepage = "https://github.com/magarcia/python-x256";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Scriptkiddi ];
  };
})
