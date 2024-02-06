{ lib
, stdenv
, fetchFromGitHub
, rocmUpdateScript
, cmake
, rocm-cmake
, clr
, openmp
, clang-tools-extra
, gtest
, buildTests ? false
, buildExamples ? false
, gpuTargets ? [ ] # gpuTargets = [ "gfx803" "gfx900" "gfx1030" ... ]
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "composable_kernel";
  version = "5.7.1";

  outputs = [
    "out"
  ] ++ lib.optionals buildTests [
    "test"
  ] ++ lib.optionals buildExamples [
    "example"
  ];

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "composable_kernel";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-Z9X+S2SijGJ8bhr9ghkkWicBUzLzs9fxPpqZxX6BBM4=";
  };

  nativeBuildInputs = [
    cmake
    rocm-cmake
    clr
    clang-tools-extra
  ];

  buildInputs = [ openmp ];

  cmakeFlags = [
    "-DCMAKE_C_COMPILER=hipcc"
    "-DCMAKE_CXX_COMPILER=hipcc"
  ] ++ lib.optionals (gpuTargets != [ ]) [
    "-DGPU_TARGETS=${lib.concatStringsSep ";" gpuTargets}"
    "-DAMDGPU_TARGETS=${lib.concatStringsSep ";" gpuTargets}"
  ] ++ lib.optionals buildTests [
    "-DGOOGLETEST_DIR=${gtest.src}" # Custom linker names
  ];

  # No flags to build selectively it seems...
  postPatch = lib.optionalString (!buildTests) ''
    substituteInPlace CMakeLists.txt \
      --replace "add_subdirectory(test)" ""
  '' + lib.optionalString (!buildExamples) ''
    substituteInPlace CMakeLists.txt \
      --replace "add_subdirectory(example)" ""
  '';

  postInstall = lib.optionalString buildTests ''
    mkdir -p $test/bin
    mv $out/bin/test_* $test/bin
  '' + lib.optionalString buildExamples ''
    mkdir -p $example/bin
    mv $out/bin/example_* $example/bin
  '';

  passthru.updateScript = rocmUpdateScript {
    name = finalAttrs.pname;
    owner = finalAttrs.src.owner;
    repo = finalAttrs.src.repo;
  };

  # Times out otherwise
  requiredSystemFeatures = [ "big-parallel" ];

  meta = with lib; {
    description = "Performance portable programming model for machine learning tensor operators";
    homepage = "https://github.com/ROCm/composable_kernel";
    license = with licenses; [ mit ];
    maintainers = teams.rocm.members;
    platforms = platforms.linux;
    broken = versions.minor finalAttrs.version != versions.minor stdenv.cc.version || versionAtLeast finalAttrs.version "6.0.0";
  };
})
