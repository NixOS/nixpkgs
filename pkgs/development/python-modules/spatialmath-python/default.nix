{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
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
  version = "1.1.16";
  pyproject = true;

  src = fetchPypi {
    pname = "spatialmath_python";
    inherit version;
    hash = "sha256-6y8EOxxXuqsDTAHW0wKOq4D17GjqouyJy5VyEHwzaiI=";
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

  meta = {
    description = "Provides spatial maths capability for Python";
    homepage = "https://pypi.org/project/spatialmath-python/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      djacu
      a-camarillo
    ];
  };
}
