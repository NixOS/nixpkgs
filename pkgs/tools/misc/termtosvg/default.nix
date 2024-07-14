{ lib, python3Packages, fetchPypi }:

python3Packages.buildPythonApplication rec {
  pname = "termtosvg";
  version = "1.1.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-7TjxYV1/hz54R2HRtAasc6u9K78MUXNi9cL9wZGdZe4=";
  };

  propagatedBuildInputs = with python3Packages; [ lxml pyte wcwidth ];

  meta = with lib; {
    homepage = "https://nbedos.github.io/termtosvg/";
    description = "Record terminal sessions as SVG animations";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
    mainProgram = "termtosvg";
  };
}
