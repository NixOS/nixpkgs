{ lib, fetchPypi, buildPythonPackage, isPy3k
, pytest, requests }:

buildPythonPackage rec {
  pname = "zm-py";
  version = "0.3.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7cac73bd4f5e729fd8b3cff6f456652c3fd76b1a11f5d539bc7e14ffc7a87e9a";
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
