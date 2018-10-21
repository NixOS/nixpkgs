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
  version = "1.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0npgi4ks0nww2d6ci791iayab0j6kz6dx3jr7bhpgkql3s4if3bw";
  };

  propagatedBuildInputs = [ six jsonpatch jsonschema jsonpointer ];

  meta = with stdenv.lib; {
    homepage = https://github.com/bcwaldon/warlock;
    description = "Python object model built on JSON schema and JSON patch";
    license = licenses.asl20;
  };

}
