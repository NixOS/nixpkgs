{
  lib,
  stdenv,
  fetchFromGitHub,
  rocmPackages,
  cmake,
  python3,
  nlohmann_json,
  gtest,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rocprof-trace-decoder";
  version = "0.1.7";

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "rocm-systems";
    # No tags (yet?)
    rev = "feeca99950c590e0b8228733405c4a1a10fa4773";
    sparseCheckout = [
      "projects/rocprof-trace-decoder"
      "shared"
    ];
    hash = "sha256-aJhPiZf5380jj2IeCipgcTEQYogr5R19UnVwKRGnkxo=";
  };

  sourceRoot = "${finalAttrs.src.name}/projects/rocprof-trace-decoder";

  patches = [
    ./use-system-dependencies.patch
    # https://github.com/ROCm/rocm-systems/pull/3800
    ./fix-test-dependency.patch
  ];

  strictDeps = true;

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    rocmPackages.rocm-comgr
    rocmPackages.rocm-runtime
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_TESTS" finalAttrs.doCheck)
  ];

  nativeCheckInputs = [
    python3
  ];

  checkInputs = [
    nlohmann_json
    gtest
  ];

  preCheck = ''
    patchShebangs test
  '';

  checkPhase =
    let
      # Sanitize tests fail because the UBSan runtime (__ubsan_vptr_type_cache) is not available for
      # LD_PRELOAD in the sandbox.
      skipPattern = "_sanitize$";
    in
    ''
      runHook preCheck

      ctest --test-dir . --output-on-failure -E '${skipPattern}'

      runHook postCheck
    '';

  doCheck = true;

  meta = {
    description = "Library for decoding ROCm thread trace data";
    homepage = "https://github.com/ROCm/rocm-systems/tree/develop/projects/rocprof-trace-decoder";
    license = with lib.licenses; [ mit ];
    teams = [ lib.teams.rocm ];
    platforms = lib.platforms.linux;
  };
})
