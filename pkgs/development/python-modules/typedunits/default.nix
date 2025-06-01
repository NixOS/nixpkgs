{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  stdenv,
  cython,
  setuptools,
  attrs,
  numpy,
  protobuf,
  pyparsing,
  pytestCheckHook,
}:

buildPythonPackage {
  pname = "typedunits";
  version = "0.0.1.dev20250509200845";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "quantumlib";
    repo = "TypedUnits";
    # PyPi ships platform- and python- specific wheels, so pin the matching source
    rev = "95e698b10454dc8dffdb708d56199a748e6dab75";
    hash = "sha256-mNo2s1sIMOa7zYfp6XyF8CBQ840+XvN0Ek59W6bRqeM=";
  };

  build-system = [
    cython
    setuptools
  ];

  dependencies = [
    attrs
    cython
    numpy
    protobuf
    pyparsing
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = lib.optionals stdenv.hostPlatform.isAarch64 [
    # Rounding differences
    "test_float_to_twelths_frac"
  ];

  disabledTestPaths = [
    # Flaky due to host timing differences under load
    "test_perf/test_array_with_dimension_performance.py"
    "test_perf/test_value_array_performance.py"
    "test_perf/test_value_performance.py"
    "test_perf/test_value_with_dimension_performance.py"
  ];

  pythonImportsCheck = [
    "tunits"
  ];

  meta = {
    description = "Units and dimensions library with support for static dimensionality checking and protobuffer serialization";
    homepage = "https://github.com/quantumlib/TypedUnits";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.sarahec ];
  };
}
