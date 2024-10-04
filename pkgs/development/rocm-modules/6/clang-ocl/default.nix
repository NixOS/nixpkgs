{ lib
, stdenv
, fetchFromGitHub
, rocmUpdateScript
, cmake
, rocm-cmake
, rocm-device-libs
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "clang-ocl";
  version = "6.1.2";

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "clang-ocl";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-rf40IXxJH6ZppgIXLOtvwj/B26as3CjlopS/Qx7exJ8=";
  };

  nativeBuildInputs = [
    cmake
    rocm-cmake
  ];

  buildInputs = [ rocm-device-libs ];

  passthru.updateScript = rocmUpdateScript {
    name = finalAttrs.pname;
    owner = finalAttrs.src.owner;
    repo = finalAttrs.src.repo;
  };

  meta = with lib; {
    description = "OpenCL compilation with clang compiler";
    homepage = "https://github.com/ROCm/clang-ocl";
    license = with licenses; [ mit ];
    maintainers = teams.rocm.members;
    platforms = platforms.linux;
    broken = versions.minor finalAttrs.version != versions.minor stdenv.cc.version || versionAtLeast finalAttrs.version "7.0.0";
  };
})
