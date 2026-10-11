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
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "rocm-systems";
    # rocprof-trace-decoder keeps its own 0.x version, so the rocm-systems
    # monorepo tag cannot be derived from finalAttrs.version like sibling packages.
    rev = "therock-10.1";
    sparseCheckout = [
      "projects/rocprof-trace-decoder"
      "shared"
    ];
    hash = "sha256-0cbkljtw/gZJwXPUpJuLXpQlXfR/MQgEGbLDsRdzpcw=";
  };

  sourceRoot = "${finalAttrs.src.name}/projects/rocprof-trace-decoder";

  strictDeps = true;

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    rocmPackages.rocm-comgr
    rocmPackages.rocm-runtime
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_TESTS" finalAttrs.finalPackage.doCheck)
    # The ATT integration tests need the pyelftools python module
    # and bundled trace-data fixtures; keep the unit tests, skip integration.
    (lib.cmakeBool "BUILD_INTEGRATION_TESTS" false)
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
    license = lib.licenses.mit;
    teams = [ lib.teams.rocm ];
    platforms = lib.platforms.linux;
  };
})
