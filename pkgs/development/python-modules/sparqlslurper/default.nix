{
  lib,
  fetchPypi,
  buildPythonPackage,
  pbr,
  rdflib,
  rdflib-shim,
  setuptools,
  sparqlwrapper,
}:

buildPythonPackage rec {
  pname = "sparqlslurper";
  version = "0.5.1";
  format = "setuptools";
  strictDeps = true;
  __structuredAttrs = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-koLrsGT8YVKlgmnRlMseeydbDwlUJaV411uW3MhR9UY=";
  };

  build-system = [
    pbr
    setuptools
  ];

  propagatedBuildInputs = [
    rdflib
    rdflib-shim
    sparqlwrapper
  ];

  pythonImportsCheck = [ "sparqlslurper" ];

  meta = {
    description = "SPARQL result slurping utilities for RDFLib";
    homepage = "https://github.com/hsolbrig/sparqlslurper";
    license = lib.licenses.cc0;
    maintainers = with lib.maintainers; [ philocalyst ];
  };
}
