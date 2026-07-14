{
  buildPythonPackage,
  lib,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "xstatic-jquery";
  version = "3.5.1.1";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    pname = "XStatic-jQuery";
    inherit (finalAttrs) version;
    hash = "sha256-4K6PjsW70oBFukvKBnZ6OL1fwnz5tx9DRYn1k3Dc0yM=";
  };

  build-system = [ setuptools ];

  # no tests implemented
  doCheck = false;

  pythonImportsCheck = [ "xstatic.pkg.jquery" ];

  meta = {
    homepage = "https://jquery.org";
    description = "jquery packaged static files for python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ makefu ];
  };
})
