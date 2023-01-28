{ lib, stdenv, fetchFromGitHub
, cmake, addOpenGLRunpath
, cudatoolkit
, cutensor
}:

let
  rev = "5aab680905d853bce0dbad4c488e4f7e9f7b2302";
  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "CUDALibrarySamples";
    inherit rev;
    sha256 = "0gwgbkq05ygrfgg5hk07lmap7n7ampxv0ha1axrv8qb748ph81xs";
  };
  commonAttrs = {
    version = lib.strings.substring 0 7 rev + "-" + lib.versions.majorMinor cudatoolkit.version;
    nativeBuildInputs = [ cmake addOpenGLRunpath ];
    buildInputs = [ cudatoolkit ];
    postFixup = ''
      for exe in $out/bin/*; do
        addOpenGLRunpath $exe
      done
    '';
    meta = {
      description = "examples of using libraries using CUDA";
      longDescription = ''
        CUDA Library Samples contains examples demonstrating the use of
        features in the math and image processing libraries cuBLAS, cuTENSOR,
        cuSPARSE, cuSOLVER, cuFFT, cuRAND, NPP and nvJPEG.
      '';
      license = lib.licenses.bsd3;
      maintainers = with lib.maintainers; [ obsidian-systems-maintenance ];
    };
  };
in

{
  cublas = stdenv.mkDerivation (commonAttrs // {
    pname = "cuda-library-samples-cublas";

    src = "${src}/cuBLASLt";
  });

  cusolver = stdenv.mkDerivation (commonAttrs // {
    pname = "cuda-library-samples-cusolver";

    src = "${src}/cuSOLVER";

    sourceRoot = "cuSOLVER/gesv";
  });

  cutensor = stdenv.mkDerivation (commonAttrs // {
    pname = "cuda-library-samples-cutensor";

    src = "${src}/cuTENSOR";

    buildInputs = [ cutensor ];

    cmakeFlags = [
      "-DCUTENSOR_EXAMPLE_BINARY_INSTALL_DIR=${builtins.placeholder "out"}/bin"
    ];

    # CUTENSOR_ROOT is double escaped
    postPatch = ''
      substituteInPlace CMakeLists.txt \
        --replace "\''${CUTENSOR_ROOT}/include" "${cutensor.dev}/include"
    '';

    CUTENSOR_ROOT = cutensor;
  });
}
