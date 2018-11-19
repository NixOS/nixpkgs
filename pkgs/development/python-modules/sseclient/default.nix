{ stdenv, buildPythonPackage, fetchPypi
, requests, six
, backports_unittest-mock, pytest, pytestrunner }:

buildPythonPackage rec {
  pname = "sseclient";
  version = "0.0.20";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0h5d3lr1g1m03cz5n3bbzrg39ympjk88qd9gkrm7bic6yp73iwrd";
  };

  propagatedBuildInputs = [ requests six ];

  checkInputs = [ backports_unittest-mock pytest pytestrunner ];

  meta = with stdenv.lib; {
    description = "Client library for reading Server Sent Event streams";
    homepage = https://github.com/btubbs/sseclient;
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
