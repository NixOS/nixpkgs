{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  writableTmpDirAsHomeHook,

  # build-system
  cmake,
  cython_0,
  ninja,
  oldest-supported-numpy,
  setuptools,
  scikit-build,

  # dependencies
  matplotlib,
  meshio,
  numpy,
  pyparsing,
  python,
  pyvista,
  scipy,
  sympy,
  tables,

  # tests
  pytest,
  openssh,
}:

buildPythonPackage rec {
  pname = "sfepy";
  version = "2024.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sfepy";
    repo = "sfepy";
    tag = "release_${version}";
    hash = "sha256-3XQqPoAM1Qw/fZ649Xk+ceaeBkZ3ypI1FSRxtYbIrxw=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "ninja<=1.11.1.1" "ninja" \
      --replace-fail "numpy<2" "numpy"

    substituteInPlace sfepy/solvers/optimize.py \
      --replace-fail "nm.Inf" "nm.inf"

    substituteInPlace sfepy/examples/quantum/quantum_common.py \
      --replace-fail "NaN" "nan"

    # slow tests
    rm sfepy/tests/test_elasticity_small_strain.py
    rm sfepy/tests/test_hyperelastic_tlul.py
    rm sfepy/tests/test_io.py
    rm sfepy/tests/test_linear_solvers.py
    rm sfepy/tests/test_poly_spaces.py
    rm sfepy/tests/test_quadratures.py
    rm sfepy/tests/test_refine_hanging.py
    rm sfepy/tests/test_term_call_modes.py
    #  ValueError: invalid literal for int() with base 10: 'np.int64(3)'
    rm sfepy/tests/test_meshio.py
  '';

  nativeBuildInputs = [
    writableTmpDirAsHomeHook
  ];

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
    matplotlib
    meshio
    numpy
    pyparsing
    pyvista
    scipy
    sympy
    tables
  ];

  pythonRelaxDeps = [
    "numpy"
  ];

  nativeCheckInputs = [
    pytest
    writableTmpDirAsHomeHook
  ];

  checkPhase = ''
    runHook preCheck

    export OMPI_MCA_plm_rsh_agent=${lib.getExe openssh}
    mv sfepy sfepy.hidden
    mkdir -p $HOME/.matplotlib
    echo "backend: ps" > $HOME/.matplotlib/matplotlibrc
    ${python.interpreter} -c "import sfepy; sfepy.test()"

    runHook postCheck
  '';

  meta = {
    homepage = "https://sfepy.org/";
    description = "Simple Finite Elements in Python";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ wd15 ];
  };
}
