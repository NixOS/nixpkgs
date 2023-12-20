{ stdenv
, lib
, buildPythonPackage
, fetchFromGitHub
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
, pyvista
, pytest
, pythonOlder
}:

buildPythonPackage rec {
  pname = "sfepy";
  version = "2023.1";
  format = "setuptools";
  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "sfepy";
    repo = "sfepy";
    rev = "release_${version}";
    hash = "sha256-PuU6DL9zftHltpYI9VZQzKGIP8l9UUU8GVChrHtpNM0=";
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
    pyvista
  ];

  postPatch = ''
    # slow tests
    rm sfepy/tests/test_io.py
    rm sfepy/tests/test_elasticity_small_strain.py
    rm sfepy/tests/test_term_call_modes.py
    rm sfepy/tests/test_refine_hanging.py
    rm sfepy/tests/test_hyperelastic_tlul.py
    rm sfepy/tests/test_poly_spaces.py
    rm sfepy/tests/test_linear_solvers.py
    rm sfepy/tests/test_quadratures.py
  '';

  nativeCheckInputs = [
    pytest
  ];

  checkPhase = ''
    export OMPI_MCA_plm_rsh_agent=${openssh}/bin/ssh
    export HOME=$TMPDIR
    mv sfepy sfepy.hidden
    mkdir -p $HOME/.matplotlib
    echo "backend: ps" > $HOME/.matplotlib/matplotlibrc
    ${python.interpreter} -c "import sfepy; sfepy.test()"
  '';

  meta = with lib; {
    homepage = "https://sfepy.org/";
    description = "Simple Finite Elements in Python";
    license = licenses.bsd3;
    maintainers = with maintainers; [ wd15 ];
  };
}
