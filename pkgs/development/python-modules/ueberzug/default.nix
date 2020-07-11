{ lib, buildPythonPackage, fetchPypi, isPy27
, libX11, libXext
, attrs, docopt, pillow, psutil, xlib }:

buildPythonPackage rec {
  pname = "ueberzug";
  version = "18.1.6";

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "13a9q9rvkbsym5nrc1y2anhyx317vj1vi8k8kln8gin2yw311pyb";
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
