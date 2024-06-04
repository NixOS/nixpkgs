{
  lib,
  toPythonModule,
  stdenv,
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
    version = "0.26.1";

    src = fetchFromGitHub {
      owner = "xtensor-stack";
      repo = "xtensor-python";
      rev = finalAttrs.version;
      sha256 = "sha256-kLFt5Ah5/ZO6wfTZQviVXeIAVok+/F/XCwpgPSagOMo=";
    };

    nativeBuildInputs = [ cmake ];
    buildInputs = [ pybind11 ];
    nativeCheckInputs = [ gtest ];
    doCheck = true;
    cmakeFlags = [ "-DBUILD_TESTS=${if finalAttrs.finalPackage.doCheck then "ON" else "OFF"}" ];

    propagatedBuildInputs = [
      xtensor
      numpy
    ];

    checkTarget = "xtest";

    meta = with lib; {
      homepage = "https://github.com/xtensor-stack/xtensor-python";
      description = "Python bindings for the xtensor C++ multi-dimensional array library";
      license = licenses.bsd3;
      maintainers = with maintainers; [ lsix ];
    };
  })
)
