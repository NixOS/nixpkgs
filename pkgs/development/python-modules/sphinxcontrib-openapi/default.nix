{ lib
, buildPythonPackage
, deepmerge
, fetchPypi
, fetchpatch
, isPy27
, setuptools-scm
, jsonschema
, picobox
, pyyaml
, sphinx-mdinclude
, sphinxcontrib-httpdomain
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-openapi";
  version = "0.8.3";
  format = "setuptools";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-nGIRdUC1J2AGrHrUrzRpbQKvJ4r6KZcSdAw2gKmp3mw=";
  };

  nativeBuildInputs = [ setuptools-scm ];
  propagatedBuildInputs = [
    deepmerge
    jsonschema
    picobox
    pyyaml
    sphinx-mdinclude
    sphinxcontrib-httpdomain
  ];

  doCheck = false;

  pythonNamespaces = [ "sphinxcontrib" ];

  meta = with lib; {
    homepage = "https://github.com/ikalnytskyi/sphinxcontrib-openapi";
    description = "OpenAPI (fka Swagger) spec renderer for Sphinx";
    license = licenses.bsd0;
    maintainers = [ maintainers.flokli ];
  };
}
