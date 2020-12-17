{ lib, buildPythonPackage, fetchPypi, isPy27
, libX11, libXext
, attrs, docopt, pillow, psutil, xlib }:

buildPythonPackage rec {
  pname = "ueberzug";
  version = "18.1.8";

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "3718db8f824ef5f6a69dc25b3f08e0a45388dd46843c61721476bad2b64345ee";
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
