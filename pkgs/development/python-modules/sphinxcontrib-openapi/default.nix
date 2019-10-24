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
  version = "0.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2a5883456c0caba0dad90f07968c75a50d5fc425a3aa06d1c538472ddf8c7e22";
  };

  propagatedBuildInputs = [setuptools_scm pyyaml jsonschema sphinxcontrib_httpdomain];

  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/ikalnytskyi/sphinxcontrib-openapi;
    description = "OpenAPI (fka Swagger) spec renderer for Sphinx";
    license = licenses.bsd0;
  };

}
