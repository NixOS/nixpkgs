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
  version = "1.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "01kajxvjp5n1p42n1kvv7rfcj2yyr44zmmzk48pywryfixr3yh6p";
  };

  propagatedBuildInputs = [ six jsonpatch jsonschema jsonpointer ];

  meta = with stdenv.lib; {
    homepage = https://github.com/bcwaldon/warlock;
    description = "Python object model built on JSON schema and JSON patch";
    license = licenses.asl20;
  };

}
