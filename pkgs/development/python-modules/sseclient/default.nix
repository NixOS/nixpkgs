{ stdenv, buildPythonPackage, fetchPypi
, requests, six
, backports_unittest-mock, pytest, pytestrunner }:

buildPythonPackage rec {
  pname = "sseclient";
  version = "0.0.22";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bf1eab60b09edbaa51e42f65a18b715367d55cfdf57c1f162886bac97bb5c6fb";
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
