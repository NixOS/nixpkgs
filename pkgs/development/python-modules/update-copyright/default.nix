{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "update-copyright";
  version = "0.6.2";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) version;
    pname = "update-copyright";
    hash = "sha256-/8y263Yq/L1+kdDhkBo69/ug2Q7eTaIaxF4Y1tZry58=";
  };

  build-system = [
    setuptools
  ];

  pythonImportsCheck = [ "update_copyright" ];

  # Has no tests
  doCheck = false;

  meta = {
    description = "Automatic copyright update tool";
    mainProgram = "update-copyright.py";
    homepage = "http://blog.tremily.us/posts/update-copyright";
    license = lib.licenses.gpl3Plus;
  };
})
