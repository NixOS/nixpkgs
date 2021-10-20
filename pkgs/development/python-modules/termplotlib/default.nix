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
  version = "0.3.8";

  src = fetchFromGitHub {
    owner = "nschloe";
    repo = pname;
    rev = "v${version}";
    sha256 = "10k70pb7554cc2zwkcgxfak8nb7iqqw6njbnaqfdz07l4v9f6smm";
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
