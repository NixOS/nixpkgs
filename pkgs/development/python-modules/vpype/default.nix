{ lib
, asteval
, buildPythonPackage
, cachetools
, click
, fetchFromGitHub
, multiprocess
, numpy
, pnoise
, poetry-core
, pytest-benchmark
, pytest-mpl
, pytest-xdist
, pytestCheckHook
, scipy
, shapely
, svgelements
, svgwrite
, tomli
}:

buildPythonPackage rec {
  version = "1.13.0";
  pname = "vpype";

  src = fetchFromGitHub {
    owner = "abey79";
    repo = "vpype";
    rev = version;
    sha256 = "sha256-HiN/Jqn24KywxNIeOxm/TAA9cIOm3QXKYkB8HysRnfI=";
  };

  format = "pyproject";

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    asteval
    cachetools
    click
    multiprocess
    numpy
    pnoise
    pytest-benchmark
    pytest-mpl
    pytest-xdist
    pytestCheckHook
    scipy
    shapely
    svgelements
    svgwrite
    tomli
  ];

  pythonImportsCheck = [ "vpype" ];
  disabledTestPaths = [
    # ignoring graphical tests
    "tests/test_show.py"
    "tests/test_viewer.py"
    "tests/test_benchmarks.py"
    "tests/test_text.py"
  ];

  meta = with lib; {
    description = "The Swiss Army knife of vector graphics for pen plotters";
    homepage = "https://github.com/abey79/vpype";
    license = licenses.mit;
    maintainers = with maintainers; [ sdedovic ];
  };
}
