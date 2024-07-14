{ lib, python3Packages, fetchPypi }:

python3Packages.buildPythonApplication rec {
  pname = "krakenx";
  version = "0.0.3";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-AAAaW1vii96byMNTr+VG2P6E5JsmmnA5PBYWlXsOHM4=";
  };

  propagatedBuildInputs = lib.singleton python3Packages.pyusb;

  doCheck = false; # there are no tests

  meta = with lib; {
    description = "Python script to control NZXT cooler Kraken X52/X62/X72";
    homepage = "https://github.com/KsenijaS/krakenx";
    license = licenses.gpl2Only;
    maintainers = [ maintainers.willibutz ];
    platforms = platforms.linux;
  };
}
