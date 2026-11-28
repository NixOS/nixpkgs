{
  lib,
  fetchPypi,
  buildPythonPackage,
  hatchling,
  pyjsg,
  rdflib,
  uv-dynamic-versioning,
}:

buildPythonPackage rec {
  pname = "shexjsg";
  version = "0.9.0";
  pyproject = true;
  strictDeps = true;
  __structuredAttrs = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-dQAW+r21SHsn4ucUFF82As06xOsN2bfXdR0M3mLA0dg=";
  };

  build-system = [
    hatchling
    uv-dynamic-versioning
  ];

  propagatedBuildInputs = [
    pyjsg
    rdflib
  ];

  pythonImportsCheck = [ "ShExJSG" ];

  meta = {
    description = "JSON schema grammar definition for ShEx 2.0";
    homepage = "https://github.com/linkml/ShExJSG";
    license = lib.licenses.cc0;
    maintainers = with lib.maintainers; [ philocalyst ];
  };
}
