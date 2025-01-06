{
  lib,
  stdenv,
  fetchFromGitHub,
  rocmUpdateScript,
  cmake,
  rocm-cmake,
  rocm-device-libs,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "clang-ocl";
  version = "6.0.2";

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "clang-ocl";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-uMSvcVJj+me2E+7FsXZ4l4hTcK6uKEegXpkHGcuist0=";
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

  meta = {
    description = "OpenCL compilation with clang compiler";
    homepage = "https://github.com/ROCm/clang-ocl";
    license = with lib.licenses; [ mit ];
    maintainers = lib.teams.rocm.members;
    platforms = lib.platforms.linux;
    broken =
      lib.versions.minor finalAttrs.version != lib.versions.minor stdenv.cc.version
      || lib.versionAtLeast finalAttrs.version "7.0.0";
  };
})
