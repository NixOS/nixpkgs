{
  lib,
  stdenv,
  toPythonModule,
  fetchFromGitHub,
  cmake,
  gtest,
  xtensor,
  pybind11,
  numpy,
}:

toPythonModule (
  stdenv.mkDerivation (finalAttrs: {
    pname = "xtensor-python";
    version = "0.28.0";

    src = fetchFromGitHub {
      owner = "xtensor-stack";
      repo = "xtensor-python";
      tag = finalAttrs.version;
      hash = "sha256-xByqAYtSRKOnllMUFdRM25bXGft/43EEpEMIlcjdrgE=";
    };

    nativeBuildInputs = [ cmake ];
    buildInputs = [ pybind11 ];
    nativeCheckInputs = [ gtest ];
    doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;
    cmakeFlags = [
      # Always build the tests, even if not running them, because testing whether
      # they can be built is a test in itself.
      (lib.cmakeBool "BUILD_TESTS" true)
    ];

    propagatedBuildInputs = [
      xtensor
      numpy
    ];

    checkTarget = "xtest";

    meta = {
      homepage = "https://github.com/xtensor-stack/xtensor-python";
      description = "Python bindings for the xtensor C++ multi-dimensional array library";
      license = lib.licenses.bsd3;
    };
  })
)
