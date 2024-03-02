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
  version = "5.7.1";

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "ROCT-Thunk-Interface";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-jAMBks2/JaXiA45B3qvLHY8fPeFcr1GHT5Jieuduqhw=";
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

  meta = with lib; {
    description = "Radeon open compute thunk interface";
    homepage = "https://github.com/ROCm/ROCT-Thunk-Interface";
    license = with licenses; [ bsd2 mit ];
    maintainers = with maintainers; [ lovesegfault ] ++ teams.rocm.members;
    platforms = platforms.linux;
    broken = versions.minor finalAttrs.version != versions.minor stdenv.cc.version || versionAtLeast finalAttrs.version "6.0.0";
  };
})
