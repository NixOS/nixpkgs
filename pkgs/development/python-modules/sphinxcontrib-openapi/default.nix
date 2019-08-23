{ stdenv
, buildPythonPackage
, fetchPypi
, setuptools_scm
, pyyaml
, jsonschema
, sphinxcontrib_httpdomain
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-openapi";
  version = "0.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9d64c8a119bfc592e6316af3e5475ce2d4d8ed6e013dc016a3f2e7971e50d7f3";
  };

  propagatedBuildInputs = [setuptools_scm pyyaml jsonschema sphinxcontrib_httpdomain];

  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/ikalnytskyi/sphinxcontrib-openapi;
    description = "OpenAPI (fka Swagger) spec renderer for Sphinx";
    license = licenses.bsd0;
  };

}
