{ stdenv, buildPythonPackage, fetchPypi
, requests, six
, backports_unittest-mock, pytestCheckHook, pytestrunner }:

buildPythonPackage rec {
  pname = "sseclient";
  version = "0.0.26";

  src = fetchPypi {
    inherit pname version;
    sha256 = "33f45ab71bb6369025d6a1014e15f12774f7ea25b7e80eeb00bd73668d5fefad";
  };

  propagatedBuildInputs = [ requests six ];

  checkInputs = [ backports_unittest-mock pytestCheckHook pytestrunner ];

  # tries to open connection to wikipedia
  disabledTests = [ "event_stream" ];

  meta = with stdenv.lib; {
    description = "Client library for reading Server Sent Event streams";
    homepage = "https://github.com/btubbs/sseclient";
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
