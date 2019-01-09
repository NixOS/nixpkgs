{ lib, python3, fetchFromGitHub }:

python3.pkgs.buildPythonApplication rec {
  pname = "termtosvg";
  version = "0.7.0";

  # tests are not available when fetching from pypi
  src = fetchFromGitHub {
    owner = "nbedos";
    repo = pname;
    rev = version;
    sha256 = "17hhdrsn9ggcrwqp2c1h2la9cwhdazfrczd7nnm5mz7w6rk25lx3";
  };

  propagatedBuildInputs = with python3.pkgs; [ lxml pyte ];

  meta = with lib; {
    homepage = https://github.com/nbedos/termtosvg;
    description = "Record terminal sessions as SVG animations";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ma27 ];
  };
}
