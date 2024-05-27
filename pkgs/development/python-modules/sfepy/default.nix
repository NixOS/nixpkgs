{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  cmake,
  cython_0,
  ninja,
  oldest-supported-numpy,
  setuptools,
  scikit-build,
  numpy,
  scipy,
  matplotlib,
  pyparsing,
  tables,
  python,
  sympy,
  meshio,
  mpi4py,
  psutil,
  openssh,
  pyvista,
  pytest,
  stdenv,
}:

buildPythonPackage rec {
  pname = "sfepy";
  version = "2024.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "sfepy";
    repo = "sfepy";
    rev = "release_${version}";
    hash = "sha256-r2Qx9uJmVS4ugJxrIxg2UscnYu1Qr4hEkcz66NyWGmA=";
  };

  build-system = [
    cmake
    cython_0
    ninja
    oldest-supported-numpy
    setuptools
    scikit-build
  ];

  dontUseCmakeConfigure = true;

  dependencies = [
    numpy
    scipy
    matplotlib
    pyparsing
    tables
    sympy
    meshio
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

  nativeCheckInputs = [ pytest ];

  checkPhase = ''
    export OMPI_MCA_plm_rsh_agent=${openssh}/bin/ssh
    export HOME=$TMPDIR
    mv sfepy sfepy.hidden
    mkdir -p $HOME/.matplotlib
    echo "backend: ps" > $HOME/.matplotlib/matplotlibrc
    ${python.interpreter} -c "import sfepy; sfepy.test()"
  '';

  meta = {
    homepage = "https://sfepy.org/";
    description = "Simple Finite Elements in Python";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ wd15 ];
    broken = stdenv.isDarwin;
  };
}
