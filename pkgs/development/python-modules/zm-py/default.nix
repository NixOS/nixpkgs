{ lib, fetchPypi, buildPythonPackage, isPy3k
, pytest, requests }:

buildPythonPackage rec {
  pname = "zm-py";
  version = "0.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1hq83svprd21r74palhs3xq15g34135349y4lrgr7c76i3f37j2q";
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
