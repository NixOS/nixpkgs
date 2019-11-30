{ lib, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "termtosvg";
  version = "1.0.0";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "1d0lmvprraspdqpn0rsqzvkkmpj8zk0crid5l39kxpjpxrv2irfg";
  };

  propagatedBuildInputs = with python3Packages; [ lxml pyte wcwidth ];

  meta = with lib; {
    homepage = https://nbedos.github.io/termtosvg/;
    description = "Record terminal sessions as SVG animations";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ma27 ];
  };
}
