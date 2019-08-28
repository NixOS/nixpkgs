{ lib
, buildPythonPackage
, fetchurl
, numpy
, scipy
, matplotlib
, pyparsing
, tables
, cython
, python
, sympy
}:

buildPythonPackage rec {
  name = "sfepy_${version}";
  version = "2019.2";

  src = fetchurl {
    url="https://github.com/sfepy/sfepy/archive/release_${version}.tar.gz";
    sha256 = "17dj0wbchcfa6x27yx4d4jix4z4nk6r2640xkqcsw0mf62x5l1pj";
  };

  propagatedBuildInputs = [
    numpy
    cython
    scipy
    matplotlib
    pyparsing
    tables
    sympy
  ];

  postPatch = ''
    # broken test
    rm tests/test_homogenization_perfusion.py

    # slow tests
    rm tests/test_input_*.py
    rm tests/test_elasticity_small_strain.py
    rm tests/test_term_call_modes.py
    rm tests/test_refine_hanging.py
    rm tests/test_hyperelastic_tlul.py
    rm tests/test_poly_spaces.py
    rm tests/test_linear_solvers.py
    rm tests/test_quadratures.py
  '';

  checkPhase = ''
    export HOME=$TMPDIR
    mv sfepy sfepy.hidden
    mkdir -p $HOME/.matplotlib
    echo "backend: ps" > $HOME/.matplotlib/matplotlibrc
    ${python.interpreter} run_tests.py -o $TMPDIR/test_outputs --raise
  '';

  meta = with lib; {
    homepage = https://sfepy.org/;
    description = "Simple Finite Elements in Python";
    license = licenses.bsd3;
    maintainers = with maintainers; [ wd15 ];
  };
}
