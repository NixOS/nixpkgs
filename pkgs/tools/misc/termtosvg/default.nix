{ lib, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "termtosvg";
  version = "0.9.0";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "1mf2vlq083mzhja449il78zpvjq6fv36pzakwrqmgxdjbsdyvxbd";
  };

  propagatedBuildInputs = with python3Packages; [ lxml pyte wcwidth ];

  meta = with lib; {
    homepage = https://nbedos.github.io/termtosvg/;
    description = "Record terminal sessions as SVG animations";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ma27 ];
  };
}
