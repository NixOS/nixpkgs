{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, exdown
, numpy
, gnuplot
}:

buildPythonPackage rec {
  pname = "termplotlib";
  version = "0.3.5";

  src = fetchFromGitHub {
    owner = "nschloe";
    repo = pname;
    rev = "v${version}";
    sha256 = "1z6bw6lkbrgjyq3ndsx20gwpai4scm1q9rjh4rdz0rvja4jdcv3z";
  };

  format = "pyproject";
  checkInputs = [ pytestCheckHook numpy exdown gnuplot ];
  pythonImportsCheck = [ "termplotlib" ];

  # there seems to be a newline in the very front of the output
  # which causes the test to fail, since it apparently doesn't
  # strip whitespace. might be a gnuplot choice? sigh...
  disabledTests = [ "test_plot_lim" ];

  meta = with lib; {
    description = "matplotlib for your terminal";
    homepage = "https://github.com/nschloe/termplotlib";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
