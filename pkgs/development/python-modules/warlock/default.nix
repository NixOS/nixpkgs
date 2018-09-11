{ stdenv
, buildPythonPackage
, fetchPypi
, six
, jsonpatch
, jsonschema
, pytest
}:

buildPythonPackage rec {
  pname = "warlock";
  version = "1.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d7403f728fce67ee2f22f3d7fa09c9de0bc95c3e7bcf6005b9c1962b77976a06";
  };

  checkInputs = [ pytest ];
  propagatedBuildInputs = [ six jsonpatch jsonschema ];

  checkPhase = ''
    pytest test/
  '';

  # json test files are not included with pypi release
  # (causes 1 test to fail) else all pass
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/bcwaldon/warlock;
    description = "Python object model built on JSON schema and JSON patch";
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
