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
    sha256 = "8375a5fb68a12054f0def91af800c821fb2232949337756ed975f88d8ea2bc97";
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
