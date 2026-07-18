{
  buildPythonPackage,
  lib,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "xstatic-bootbox";
  version = "5.5.1.1";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    pname = "XStatic-Bootbox";
    inherit (finalAttrs) version;
    hash = "sha256-SyEguzOh2K2o+eBTKtmZh6oDh5sXsIv9xrgybW63wgU=";
  };

  build-system = [ setuptools ];

  # no tests implemented
  doCheck = false;

  pythonImportsCheck = [ "xstatic.pkg.bootbox" ];

  meta = {
    homepage = "https://bootboxjs.com";
    description = "Bootboxjs packaged static files for python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ makefu ];
  };
})
