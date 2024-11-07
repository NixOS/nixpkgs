{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  oldest-supported-numpy,
  setuptools,
  ansitable,
  matplotlib,
  numpy,
  scipy,
  typing-extensions,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "spatialmath-python";
  version = "1.1.13";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "spatialmath_python";
    inherit version;
    hash = "sha256-BhIB4VapnARkzyhps8xRWnQTAlRB8aVPDpNuN/FNezo=";
  };

  build-system = [
    oldest-supported-numpy
    setuptools
  ];

  pythonRemoveDeps = [ "pre-commit" ];

  pythonRelaxDeps = [ "matplotlib" ];

  dependencies = [
    ansitable
    matplotlib
    numpy
    scipy
    typing-extensions
  ];

  pythonImportsCheck = [ "spatialmath" ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTestPaths = [
    # tests hang
    "tests/test_spline.py"
  ];

  env.MPLBACKEND = lib.optionalString stdenv.hostPlatform.isDarwin "Agg";

  meta = with lib; {
    description = "Provides spatial maths capability for Python";
    homepage = "https://pypi.org/project/spatialmath-python/";
    license = licenses.mit;
    maintainers = with maintainers; [
      djacu
      a-camarillo
    ];
  };
}
