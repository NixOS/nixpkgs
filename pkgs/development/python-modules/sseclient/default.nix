{ stdenv, buildPythonPackage, fetchPypi
, requests, six
, backports_unittest-mock, pytest, pytestrunner }:

buildPythonPackage rec {
  pname = "sseclient";
  version = "0.0.19";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7a2ea3f4c8525ae9a677bc8193df5db88e23bcaafcc34938a1ee665975703a9f";
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
