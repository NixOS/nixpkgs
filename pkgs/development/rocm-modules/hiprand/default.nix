{
  lib,
  stdenv,
  fetchFromGitHub,
  rocmUpdateScript,
  cmake,
  rocm-cmake,
  clr,
  rocrand,
  gtest,
  buildTests ? false,
  gpuTargets ? clr.localGpuTargets or [ ],
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hiprand";
  version = "7.2.2";

  outputs = [
    "out"
  ]
  ++ lib.optionals buildTests [
    "test"
  ];

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "rocm-libraries";
    rev = "rocm-${finalAttrs.version}";
    sparseCheckout = [
      "projects/hiprand"
      "shared"
    ];
    hash = "sha256-bjcwjN1dNukhoDAbiSpATlK6dtAwM8bOJTe3IjhdwwY=";
  };
  sourceRoot = "${finalAttrs.src.name}/projects/hiprand";

  nativeBuildInputs = [
    cmake
    rocm-cmake
    clr
  ];

  buildInputs = [ rocrand ] ++ (lib.optionals buildTests [ gtest ]);

  cmakeFlags = [
    "-DHIP_ROOT_DIR=${clr}"
    # Manually define CMAKE_INSTALL_<DIR>
    # See: https://github.com/NixOS/nixpkgs/pull/197838
    "-DCMAKE_INSTALL_BINDIR=bin"
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
  ]
  ++ lib.optionals (gpuTargets != [ ]) [
    "-DAMDGPU_TARGETS=${lib.concatStringsSep ";" gpuTargets}"
  ]
  ++ lib.optionals buildTests [
    "-DBUILD_TEST=ON"
  ];

  postInstall = lib.optionalString buildTests ''
    mkdir -p $test/bin
    mv $out/bin/test_* $test/bin
    rm -r $out/bin/hipRAND
    # Fail if bin/ isn't actually empty
    rmdir $out/bin
  '';

  passthru.updateScript = rocmUpdateScript { inherit finalAttrs; };

  meta = {
    description = "HIP wrapper for rocRAND and cuRAND";
    homepage = "https://github.com/ROCm/rocm-libraries/tree/develop/projects/hiprand";
    license = with lib.licenses; [ mit ];
    teams = [ lib.teams.rocm ];
    platforms = lib.platforms.linux;
  };
})
