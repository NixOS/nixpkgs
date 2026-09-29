{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pillow,
  requests,
}:

buildPythonPackage (finalAttrs: {
  pname = "staticmap";
  version = "0.5.7";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-x6lrkCumEpLoGMILCBBhnWuBps21C8wauS1QrE2yCn8=";
  };

  build-system = [ setuptools ];

  dependencies = [
    requests
    pillow
  ];

  pythonImportsCheck = [ "staticmap" ];

  # Tests seem to be broken
  doCheck = false;

  meta = {
    description = "Small, python-based library for creating map images with lines and markers";
    homepage = "https://pypi.org/project/staticmap/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ traxys ];
  };
})
