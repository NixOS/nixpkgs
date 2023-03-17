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
, sphinxcontrib_httpdomain
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-openapi";
  version = "0.8.1";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-BPz4fCWTRRYqUEzj3+4PcTifUHw3l3mNxTHHdImVtOs=";
  };

  nativeBuildInputs = [ setuptools-scm ];
  propagatedBuildInputs = [
    deepmerge
    jsonschema
    picobox
    pyyaml
    sphinx-mdinclude
    sphinxcontrib_httpdomain
  ];

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/ikalnytskyi/sphinxcontrib-openapi";
    description = "OpenAPI (fka Swagger) spec renderer for Sphinx";
    license = licenses.bsd0;
    maintainers = [ maintainers.flokli ];
  };
}
