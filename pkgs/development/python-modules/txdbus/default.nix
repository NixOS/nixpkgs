{
  lib,
  buildPythonPackage,
  fetchPypi,
  six,
  twisted,
}:

buildPythonPackage rec {
  pname = "txdbus";
  version = "1.1.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-g3Wl+2ihIFTw3vka+ADIIfsiMpSTN3Vu2XX4jY6ivJc=";
  };

  propagatedBuildInputs = [
    six
    twisted
  ];
  pythonImportsCheck = [ "txdbus" ];

  meta = with lib; {
    description = "Native Python implementation of DBus for Twisted";
    homepage = "https://github.com/cocagne/txdbus";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ oxzi ];
  };
}
