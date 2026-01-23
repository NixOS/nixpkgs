{
  lib,
  replaceVars,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  exdown,
  numpy,
  gnuplot,
  setuptools,
}:

buildPythonPackage rec {
  pname = "termplotlib";
  version = "0.3.9";

  src = fetchFromGitHub {
    owner = "nschloe";
    repo = "termplotlib";
    rev = "v${version}";
    sha256 = "1qfrv2w7vb2bbjvd5lqfq57c23iqkry0pwmif1ha3asmz330rja1";
  };

  nativeBuildInputs = [ setuptools ];

  pyproject = true;
  nativeCheckInputs = [
    pytestCheckHook
    exdown
  ];
  pythonImportsCheck = [ "termplotlib" ];

  propagatedBuildInputs = [ numpy ];

  patches = [
    (replaceVars ./gnuplot-subprocess.patch {
      gnuplot = "${gnuplot.out}/bin/gnuplot";
    })
  ];

  # The current gnuplot version renders slightly different test
  # graphs, with emphasis on slightly. The plots are still correct.
  # Tests pass on gnuplot 5.4.1, but fail on 5.4.2.
  disabledTests = [
    "test_plot"
    "test_nolabel"
  ];

  meta = {
    description = "Matplotlib for your terminal";
    homepage = "https://github.com/nschloe/termplotlib";
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = with lib.maintainers; [ thoughtpolice ];
  };
}
