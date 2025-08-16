{
  lib,
  buildPythonPackage,
  fetchPypi,
  isPy27,
  libX11,
  libXext,
  attrs,
  docopt,
  pillow,
  psutil,
  xlib,
}:

buildPythonPackage rec {
  pname = "ueberzug";
  version = "18.3.1";
  format = "setuptools";

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-1Lk4E5YwEq2mUnYbIWDhzz9/CCwfXMJ11/TtJ44ugOk=";
  };

  buildInputs = [
    libX11
    libXext
  ];

  propagatedBuildInputs = [
    attrs
    docopt
    pillow
    psutil
    xlib
  ];

  doCheck = false;

  pythonImportsCheck = [ "ueberzug" ];

  meta = with lib; {
    homepage = "https://github.com/seebye/ueberzug";
    description = "Alternative for w3mimgdisplay";
    mainProgram = "ueberzug";
    license = licenses.gpl3;
    maintainers = with maintainers; [ Br1ght0ne ];
  };
}
