{ stdenv
, buildPythonPackage
, fetchPypi
, sortedcontainers
}:

buildPythonPackage rec {
  pname = "sortedcollections";
  version = "1.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "12q1gf81l53mv634hk259aql69k9572nfv5gsn8gxlywdly2z63b";
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
