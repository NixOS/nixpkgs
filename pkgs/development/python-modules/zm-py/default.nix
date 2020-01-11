{ lib, fetchPypi, buildPythonPackage, isPy3k
, pytest, requests }:

buildPythonPackage rec {
  pname = "zm-py";
  version = "0.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f9693ca046de4ea12c1afb5c67709ec0c2a48744566c0a1a9327348e1a1617b0";
  };

  disabled = !isPy3k;

  propagatedBuildInputs = [ requests ];

  checkInputs = [ pytest ];

  checkPhase = ''
    PYTHONPATH="./zoneminder:$PYTHONPATH" pytest
  '';

  meta = with lib; {
    description = "A loose python wrapper around the ZoneMinder REST API";
    homepage = https://github.com/rohankapoorcom/zm-py;
    license = licenses.asl20;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
