{ stdenv, buildPythonPackage, fetchPypi, isPy27
, requests, six
, backports_unittest-mock, pytestCheckHook, pytestrunner }:

buildPythonPackage rec {
  pname = "sseclient";
  version = "0.0.27";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b2fe534dcb33b1d3faad13d60c5a7c718e28f85987f2a034ecf5ec279918c11c";
  };

  propagatedBuildInputs = [ requests six ];

  # some tests use python3 strings
  doCheck = !isPy27;
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
