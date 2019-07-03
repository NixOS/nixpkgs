{ lib, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "termtosvg";
  version = "0.8.0";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "e3a0a7bd511028c96d242525df807a23e6f22e55b111a7ee861f294a86224b0c";
  };

  propagatedBuildInputs = with python3Packages; [ lxml pyte ];

  meta = with lib; {
    homepage = https://nbedos.github.io/termtosvg/;
    description = "Record terminal sessions as SVG animations";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ma27 ];
  };
}
