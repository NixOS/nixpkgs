{ lib, buildPythonPackage, fetchPypi, tornado, paramiko }:

buildPythonPackage rec {
  pname = "webssh";
  version = "1.5.3";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Au6PE8jYm8LkEp0B1ymW//ZkrkcV0BauwufQmrHLEU4=";
  };

  propagatedBuildInputs = [ tornado paramiko ];

  pythonImportsCheck = [ "webssh" ];

  meta = with lib; {
    homepage = "https://github.com/huashengdun/webssh/";
    description = "Web based ssh client";
    license = licenses.mit;
    maintainers = with maintainers; [ davidtwco ];
  };
}
