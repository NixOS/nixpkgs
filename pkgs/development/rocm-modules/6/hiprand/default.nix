{ lib
, stdenv
, fetchFromGitHub
, rocmUpdateScript
, cmake
, rocm-cmake
, clr
, rocrand
, gtest
, buildTests ? false
, gpuTargets ? [ ]
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hiprand";
  version = "6.0.2";

  outputs = [
    "out"
  ] ++ lib.optionals buildTests [
    "test"
  ];

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "hipRAND";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-uGHzOhUX5JEknVFwhHhWFdPmwLS/TuaXYMeItS7tXIg=";
  };

  nativeBuildInputs = [
    cmake
    rocm-cmake
    clr
  ];

  buildInputs = [ rocrand ] ++ (lib.optionals buildTests [ gtest ]);

  cmakeFlags = [
    "-DCMAKE_C_COMPILER=hipcc"
    "-DCMAKE_CXX_COMPILER=hipcc"
    "-DHIP_ROOT_DIR=${clr}"
    # Manually define CMAKE_INSTALL_<DIR>
    # See: https://github.com/NixOS/nixpkgs/pull/197838
    "-DCMAKE_INSTALL_BINDIR=bin"
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
  ] ++ lib.optionals (gpuTargets != [ ]) [
    "-DAMDGPU_TARGETS=${lib.concatStringsSep ";" gpuTargets}"
  ] ++ lib.optionals buildTests [
    "-DBUILD_TEST=ON"
  ];

  postInstall = lib.optionalString buildTests ''
    mkdir -p $test/bin
    mv $out/bin/test_* $test/bin
    rm -r $out/bin/hipRAND
    # Fail if bin/ isn't actually empty
    rmdir $out/bin
  '';

  passthru.updateScript = rocmUpdateScript {
    name = finalAttrs.pname;
    owner = finalAttrs.src.owner;
    repo = finalAttrs.src.repo;
  };

  meta = with lib; {
    description = "A HIP wrapper for rocRAND and cuRAND";
    homepage = "https://github.com/ROCm/hipRAND";
    license = with licenses; [ mit ];
    maintainers = teams.rocm.members;
    platforms = platforms.linux;
    broken = versions.minor finalAttrs.version != versions.minor stdenv.cc.version || versionAtLeast finalAttrs.version "7.0.0";
  };
})
