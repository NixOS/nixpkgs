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
  version = "18.1.9";
  format = "setuptools";

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "7ce49f351132c7d1b0f8097f6e4c5635376151ca59318540da3e296e5b21adc3";
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
    description = "An alternative for w3mimgdisplay";
    mainProgram = "ueberzug";
    license = licenses.gpl3;
    maintainers = with maintainers; [ Br1ght0ne ];
  };
}
