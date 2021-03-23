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
, meshio
, mpi4py
, psutil
, openssh
, pythonOlder
}:

buildPythonPackage rec {
  name = "sfepy";
  version = "2020.4";
  disabled = pythonOlder "3.8";

  src = fetchurl {
    url="https://github.com/sfepy/sfepy/archive/release_${version}.tar.gz";
    sha256 = "1wb0ik6kjg3mksxin0abr88bhsly67fpg36qjdzabhj0xn7j1yaz";
  };

  propagatedBuildInputs = [
    numpy
    cython
    scipy
    matplotlib
    pyparsing
    tables
    sympy
    meshio
    mpi4py
    psutil
    openssh
  ];

  postPatch = ''
    # broken tests
    rm tests/test_meshio.py

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
    export OMPI_MCA_plm_rsh_agent=${openssh}/bin/ssh
    export HOME=$TMPDIR
    mv sfepy sfepy.hidden
    mkdir -p $HOME/.matplotlib
    echo "backend: ps" > $HOME/.matplotlib/matplotlibrc
    ${python.interpreter} run_tests.py -o $TMPDIR/test_outputs --raise
  '';

  meta = with lib; {
    homepage = "https://sfepy.org/";
    description = "Simple Finite Elements in Python";
    license = licenses.bsd3;
    maintainers = with maintainers; [ wd15 ];
  };
}
