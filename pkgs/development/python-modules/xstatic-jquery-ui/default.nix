{
  buildPythonPackage,
  lib,
  fetchPypi,
  setuptools_80,
  xstatic-jquery,
}:

buildPythonPackage (finalAttrs: {
  pname = "xstatic-jquery-ui";
  version = "1.13.0.2";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    pname = "XStatic-jquery-ui";
    inherit (finalAttrs) version;
    hash = "sha256-EbKqfqoa1pxuWUyuEagXqPoXHOyc64KuLKS6fpPVrkM=";
  };

  build-system = [ setuptools_80 ];

  # no tests implemented
  doCheck = false;

  dependencies = [ xstatic-jquery ];

  pythonImportsCheck = [ "xstatic.pkg.jquery_ui" ];

  meta = {
    homepage = "https://jqueryui.com/";
    description = "jquery-ui packaged static files for python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ makefu ];
  };
})
