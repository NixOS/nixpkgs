{
  buildPythonPackage,
  lib,
  fetchPypi,
  setuptools_80,
}:

buildPythonPackage (finalAttrs: {
  pname = "xstatic-jquery";
  version = "3.7.1.1";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    pname = "XStatic-jQuery";
    inherit (finalAttrs) version;
    hash = "sha256-DCrHgNg4i/2LlFhvag+GVB6HArX8lvHe2ZeGYhSAlEU=";
  };

  build-system = [ setuptools_80 ];

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
