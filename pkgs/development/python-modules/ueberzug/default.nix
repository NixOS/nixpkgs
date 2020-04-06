{ lib, buildPythonPackage, fetchPypi, isPy27
, libX11, libXext
, attrs, docopt, pillow, psutil, xlib }:

buildPythonPackage rec {
  pname = "ueberzug";
  version = "18.1.5";

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1rj864sdn1975v59i8j3cfa9hni1hacq0z2b8m7wib0da9apygby";
  };

  buildInputs = [ libX11 libXext ];
  propagatedBuildInputs = [ attrs docopt pillow psutil xlib ];

  meta = with lib; {
    homepage = "https://github.com/seebye/ueberzug";
    description = "An alternative for w3mimgdisplay";
    license = licenses.gpl3;
    maintainers = with maintainers; [ filalex77 ];
  };
}
