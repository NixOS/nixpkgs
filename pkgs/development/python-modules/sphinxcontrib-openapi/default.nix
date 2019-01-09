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
  version = "0.3.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "411da1819fda0593976a157f1a14ec1cfaef9ee1b4b708e795d0bf3953f0142b";
  };

  propagatedBuildInputs = [setuptools_scm pyyaml jsonschema sphinxcontrib_httpdomain];

  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/ikalnytskyi/sphinxcontrib-openapi;
    description = "OpenAPI (fka Swagger) spec renderer for Sphinx";
    license = licenses.bsd0;
  };

}
