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
  version = "0.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0fyniq37nnmhrk4j7mzvg6vfcpb624hb9x70g6mccyw4xrnhadv6";
  };

  propagatedBuildInputs = [setuptools_scm pyyaml jsonschema sphinxcontrib_httpdomain];

  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/ikalnytskyi/sphinxcontrib-openapi;
    description = "OpenAPI (fka Swagger) spec renderer for Sphinx";
    license = licenses.bsd0;
  };

}
