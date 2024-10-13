{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "chardet";
  version = "2.3.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-5T44s6Sv5tETLeYrdACkrDY0Utxd/PjYjo4MzmY8aKo=";
  };

  meta = with lib; {
    homepage = "https://github.com/chardet/chardet";
    description = "Universal encoding detector";
    license = licenses.lgpl2;
    maintainers = with maintainers; [
      domenkozar
      efirestone
    ];
  };
}
