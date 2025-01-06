{ lib
, stdenv
, fetchFromGitHub
, rocmUpdateScript
, pkg-config
, cmake
, libdrm
, numactl
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rocm-thunk";
  version = "6.0.2";

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "ROCT-Thunk-Interface";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-F6Qi+A9DuSx2e4WSfp4cnniKr0CkCZcZqsKwQmmZHhk=";
  };

  nativeBuildInputs = [
    pkg-config
    cmake
  ];

  buildInputs = [
    libdrm
    numactl
  ];

  cmakeFlags = [
    # Manually define CMAKE_INSTALL_<DIR>
    # See: https://github.com/NixOS/nixpkgs/pull/197838
    "-DCMAKE_INSTALL_BINDIR=bin"
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
  ];

  passthru.updateScript = rocmUpdateScript {
    name = finalAttrs.pname;
    owner = finalAttrs.src.owner;
    repo = finalAttrs.src.repo;
  };

  meta = {
    description = "Radeon open compute thunk interface";
    homepage = "https://github.com/ROCm/ROCT-Thunk-Interface";
    license = with lib.licenses; [ bsd2 mit ];
    maintainers = with lib.maintainers; [ lovesegfault ] ++ lib.teams.rocm.members;
    platforms = lib.platforms.linux;
    broken = lib.versions.minor finalAttrs.version != lib.versions.minor stdenv.cc.version || lib.versionAtLeast finalAttrs.version "7.0.0";
  };
})
