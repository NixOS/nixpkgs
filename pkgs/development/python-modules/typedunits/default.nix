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

buildPythonPackage rec {
  pname = "typedunits";
  version = "0.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "quantumlib";
    repo = "TypedUnits";
    tag = "v${version}";
    hash = "sha256-g/kUPEtdyNvcWJOqcTCF27pW22WTg0EiHoEXgSs2xMs=";
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

  disabledTests = lib.optionals stdenv.hostPlatform.isAarch [
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
    maintainers = with lib.maintainers; [ sarahec ];
  };
}
