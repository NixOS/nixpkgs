{ lib, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "termtosvg";
  version = "1.1.0";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "1vk5kn8w3zf2ymi76l8cpwmvvavkmh3b9lb18xw3x1vzbmhz2f7d";
  };

  propagatedBuildInputs = with python3Packages; [ lxml pyte wcwidth ];

  meta = with lib; {
    homepage = https://nbedos.github.io/termtosvg/;
    description = "Record terminal sessions as SVG animations";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ma27 ];
  };
}
