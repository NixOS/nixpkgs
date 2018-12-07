{ lib, python3, fetchFromGitHub }:

python3.pkgs.buildPythonApplication rec {
  pname = "termtosvg";
  version = "0.6.0";

  # tests are not available when fetching from pypi
  src = fetchFromGitHub {
    owner = "nbedos";
    repo = pname;
    rev = version;
    sha256 = "07d9ashxph16phhawypm99wlx82975hqk08v1n56hxr0nr4f7nd2";
  };

  propagatedBuildInputs = with python3.pkgs; [ lxml pyte ];

  meta = with lib; {
    homepage = https://github.com/nbedos/termtosvg;
    description = "Record terminal sessions as SVG animations";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ma27 ];
  };
}
