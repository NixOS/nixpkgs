{
  lib,
  buildPythonPackage,
  fetchPypi,
  sdbus,
}:

let
  pname = "sdbus-networkmanager";
  version = "2.0.0";
in
buildPythonPackage {
  format = "setuptools";
  inherit pname version;

  propagatedBuildInputs = [ sdbus ];

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-NXKsOoGJxoPsBBassUh2F3Oo8Iga09eLbW9oZO/5xQs=";
  };

  meta = with lib; {
    description = "Python-sdbus binds for NetworkManager";
    homepage = "https://github.com/python-sdbus/python-sdbus-networkmanager";
    license = licenses.lgpl2;
    maintainers = with maintainers; [ camelpunch ];
    platforms = platforms.linux;
  };
}
