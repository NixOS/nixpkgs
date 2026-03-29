{
  lib,
  stdenv,
  fetchRocmMonorepoSource,
  rocmVersion,
  cmake,
  rocm-cmake,
  clr,
  rocrand,
  gtest,
  buildTests ? false,
  gpuTargets ? clr.localGpuTargets or [ ],
}:

let
  source = rec {
    repo = "rocm-libraries";
    version = rocmVersion;
    sourceSubdir = "projects/hiprand";
    hash = "sha256-7+qoimAqqxxSdbR5+x1t9gpOMakkvR2zg3K3dredCbw=";
    src = fetchRocmMonorepoSource {
      inherit
        hash
        repo
        sourceSubdir
        version
        ;
    };
    sourceRoot = "${src.name}/${sourceSubdir}";
    homepage = "https://github.com/ROCm/${repo}/tree/rocm-${version}/${sourceSubdir}";
  };
in
stdenv.mkDerivation {
  pname = "hiprand";
  inherit (source) version src sourceRoot;

  outputs = [
    "out"
  ]
  ++ lib.optionals buildTests [
    "test"
  ];

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

  meta = {
    inherit (source) homepage;
    description = "HIP wrapper for rocRAND and cuRAND";
    license = with lib.licenses; [ mit ];
    teams = [ lib.teams.rocm ];
    platforms = lib.platforms.linux;
  };
}
