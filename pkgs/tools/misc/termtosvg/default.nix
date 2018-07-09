{ lib, python3, fetchFromGitHub }:

python3.pkgs.buildPythonApplication rec {
  pname = "termtosvg";
  version = "0.3.0";

  # tests are not available when fetching from pypi
  src = fetchFromGitHub {
    owner = "nbedos";
    repo = pname;
    rev = version;
    sha256 = "09hw0467pyfj5gwn3768b3rvs5ch3wb1kaax7zsqjd7mw2qh0cjw";
  };

  propagatedBuildInputs = with python3.pkgs; [ svgwrite pyte ];

  checkInputs = [ python3.pkgs.mock ];
  preCheck = "export HOME=$(mktemp -d)";
  postCheck = "unset HOME";

  meta = with lib; {
    homepage = https://github.com/nbedos/termtosvg;
    description = "Record terminal sessions as SVG animations";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ma27 ];
  };
}
