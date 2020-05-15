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
  version = "0.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "02pkzcmxikcfvkvcfsclnhymzl1lc84jz6vmdaslbgh4j5vlp5ym";
  };

  propagatedBuildInputs = [setuptools_scm pyyaml jsonschema sphinxcontrib_httpdomain];

  doCheck = false;

  meta = with stdenv.lib; {
    homepage = "https://github.com/ikalnytskyi/sphinxcontrib-openapi";
    description = "OpenAPI (fka Swagger) spec renderer for Sphinx";
    license = licenses.bsd0;
  };

}
