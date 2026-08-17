{
  buildPythonPackage,
  lib,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "xstatic-bootstrap";
  version = "5.3.8.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    pname = "xstatic_bootstrap";
    inherit (finalAttrs) version;
    hash = "sha256-BPXMlbvlQ40ehR0GxMoa1/hL02oJtN5aH1S1JOhQaFk=";
  };

  build-system = [ setuptools ];

  # no tests implemented
  doCheck = false;

  pythonImportsCheck = [ "xstatic.pkg.bootstrap" ];

  meta = {
    homepage = "https://getbootstrap.com";
    description = "Bootstrap packaged static files for python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ makefu ];
  };
})
