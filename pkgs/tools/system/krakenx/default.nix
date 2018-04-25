{ lib, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "krakenx";
  version = "0.0.1";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "1vxyindph81srya0pfmb3n64n8h7ghp38ak86vc2zc5nyirf5zq8";
  };

  propagatedBuildInputs = lib.singleton python3Packages.pyusb;

  doCheck = false; # there are no tests

  meta = with lib; {
    description = "Python script to control NZXT cooler Kraken X52/X62";
    homepage = https://github.com/KsenijaS/krakenx;
    license = licenses.gpl2;
    maintainers = [ maintainers.willibutz ];
    platforms = platforms.linux;
  };
}
