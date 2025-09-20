{
  lib,
  stdenv,
  eigen,
  frugally-deep,
  functionalplus,
  nlohmann_json,
  src,
  version,
}:

stdenv.mkDerivation {
  pname = "miopen-frugally-deep-model-test";
  inherit version src;

  dontConfigure = true;
  dontInstall = true;
  doCheck = true;

  buildPhase = ''
    runHook preBuild

    $CXX -std=c++20 \
        -I${lib.getDev eigen}/include/eigen3 \
        -I${lib.getDev functionalplus}/include \
        -I${lib.getDev frugally-deep}/include \
        -I${lib.getDev nlohmann_json}/include \
        ${./test-frugally-deep-model-loading.cpp} \
        -o test_models

    runHook postBuild
  '';

  checkPhase = ''
    runHook preCheck

    echo "Running model loading tests..."
    SRC_DIR="${src}" ./test_models
    mkdir -p $out

    runHook postCheck
  '';

  meta = {
    description = "Test that frugally-deep can load MIOpen model files";
    maintainers = with lib.teams; [ rocm ];
    platforms = lib.platforms.linux;
  };
}
