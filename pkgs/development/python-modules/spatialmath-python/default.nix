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

buildPythonPackage (finalAttrs: {
  pname = "spatialmath-python";
  version = "1.1.18";
  pyproject = true;

  src = fetchPypi {
    pname = "spatialmath_python";
    inherit (finalAttrs) version;
    hash = "sha256-39JluT9RUsAuuMBb/I1fgg52yqcVrL33u48tYKarIuw=";
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
    homepage = "https://github.com/rai-opensource/spatialmath-python";
    changelog = "https://github.com/rai-opensource/spatialmath-python/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      djacu
      a-camarillo
    ];
  };
})
