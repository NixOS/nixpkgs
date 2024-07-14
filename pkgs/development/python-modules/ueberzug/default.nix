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
    hash = "sha256-fOSfNREyx9Gw+Al/bkxWNTdhUcpZMYVA2j4pblshrcM=";
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
