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
  version = "0.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1c1bd10d7653912c59a42f727c62cbb7b75f7905ddd9ccc477ebfd1bc69f0cf3";
  };

  propagatedBuildInputs = [setuptools_scm pyyaml jsonschema sphinxcontrib_httpdomain];

  doCheck = false;

  meta = with stdenv.lib; {
    homepage = "https://github.com/ikalnytskyi/sphinxcontrib-openapi";
    description = "OpenAPI (fka Swagger) spec renderer for Sphinx";
    license = licenses.bsd0;
  };

}
