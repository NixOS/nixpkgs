{ lib, fetchPypi, buildPythonPackage, isPy3k
, pytest, requests }:

buildPythonPackage rec {
  pname = "zm-py";
  version = "0.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4cd1a2191ed1b8414b0c962a5a7c7ee0c573613da751178669685cfa118b9ca7";
  };

  disabled = !isPy3k;

  propagatedBuildInputs = [ requests ];

  checkInputs = [ pytest ];

  checkPhase = ''
    PYTHONPATH="./zoneminder:$PYTHONPATH" pytest
  '';

  meta = with lib; {
    description = "A loose python wrapper around the ZoneMinder REST API";
    homepage = "https://github.com/rohankapoorcom/zm-py";
    license = licenses.asl20;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
