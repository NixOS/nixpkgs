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
    version = "0.27.0";

    src = fetchFromGitHub {
      owner = "xtensor-stack";
      repo = "xtensor-python";
      rev = finalAttrs.version;
      hash = "sha256-Cy/aXuiriE/qxSd4Apipzak30DjgE7jX8ai1ThJ/VnE=";
    };

    nativeBuildInputs = [ cmake ];
    buildInputs = [ pybind11 ];
    nativeCheckInputs = [ gtest ];
    doCheck = true;
    cmakeFlags = [
      # Always build the tests, even if not running them, because testing whether
      # they can be built is a test in itself.
      "-DBUILD_TESTS=ON"
    ];

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
