{ stdenv, buildPythonPackage, fetchPypi
, requests, six
, backports_unittest-mock, pytest, pytestrunner }:

buildPythonPackage rec {
  pname = "sseclient";
  version = "0.0.23";

  src = fetchPypi {
    inherit pname version;
    sha256 = "82a1d281b2bcb98847882069bde57a6772156f9539ddefbb78fea4f915197ec3";
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
