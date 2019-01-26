{ lib, python3, fetchFromGitHub }:

python3.pkgs.buildPythonApplication rec {
  pname = "termtosvg";
  version = "0.8.0";

  # tests are not available when fetching from pypi
  src = fetchFromGitHub {
    owner = "nbedos";
    repo = pname;
    rev = version;
    sha256 = "0si5l8cdbzapcibr4yavhld2vhfrpk7qj4cy7m4ws7js8g9iwzd4";
  };

  propagatedBuildInputs = with python3.pkgs; [ lxml pyte ];

  meta = with lib; {
    homepage = https://nbedos.github.io/termtosvg/;
    description = "Record terminal sessions as SVG animations";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ma27 ];
  };
}
