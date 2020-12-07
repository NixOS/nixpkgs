{ lib, buildPythonPackage, fetchPypi, isPy27
, libX11, libXext
, attrs, docopt, pillow, psutil, xlib }:

buildPythonPackage rec {
  pname = "ueberzug";
  version = "18.1.7";

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "ef0d6ac5815446ede654a38da550d2c44abd0fc05c901b2232935a65bcbca875";
  };

  buildInputs = [ libX11 libXext ];

  propagatedBuildInputs = [ attrs docopt pillow psutil xlib ];

  doCheck = false;

  pythonImportsCheck = [ "ueberzug" ];

  meta = with lib; {
    homepage = "https://github.com/seebye/ueberzug";
    description = "An alternative for w3mimgdisplay";
    license = licenses.gpl3;
    maintainers = with maintainers; [ Br1ght0ne ];
  };
}
