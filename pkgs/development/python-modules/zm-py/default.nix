{ lib, fetchPypi, buildPythonPackage, isPy3k
, pytest, requests }:

buildPythonPackage rec {
  pname = "zm-py";
  version = "0.5.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b391cca0e52f2a887aa7a46c314b73335b7e3341c428b425fcf314983e5ebb36";
  };

  disabled = !isPy3k;

  propagatedBuildInputs = [ requests ];

  nativeCheckInputs = [ pytest ];

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
