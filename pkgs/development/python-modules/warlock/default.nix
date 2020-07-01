{ stdenv
, buildPythonPackage
, fetchPypi
, six
, jsonpatch
, jsonschema
, jsonpointer
}:

buildPythonPackage rec {
  pname = "warlock";
  version = "1.3.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a093c4d04b42b7907f69086e476a766b7639dca50d95edc83aef6aeab9db2090";
  };

  propagatedBuildInputs = [ six jsonpatch jsonschema jsonpointer ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/bcwaldon/warlock";
    description = "Python object model built on JSON schema and JSON patch";
    license = licenses.asl20;
  };

}
