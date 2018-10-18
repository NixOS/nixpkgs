{ stdenv
, buildPythonPackage
, fetchPypi
, sortedcontainers
}:

buildPythonPackage rec {
  pname = "sortedcollections";
  version = "0.4.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "12dlzln9gyv8smsy2k6d6dmr0ywrpwyrr1cjy649ia5h1g7xdvwa";
  };

  buildInputs = [ sortedcontainers ];

  # wants to test all python versions with tox:
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Python Sorted Collections";
    homepage = http://www.grantjenks.com/docs/sortedcollections/;
    license = licenses.asl20;
  };

}
