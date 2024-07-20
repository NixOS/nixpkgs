{ lib
, stdenv
, fetchFromGitHub
, rocmUpdateScript
, cmake
, rocm-cmake
, libxml2
}:

let
  llvmNativeTarget =
    if stdenv.isx86_64 then "X86"
    else if stdenv.isAarch64 then "AArch64"
    else throw "Unsupported ROCm LLVM platform";
in stdenv.mkDerivation (finalAttrs: {
  pname = "rocm-device-libs";
  version = "5.7.1";

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "ROCm-Device-Libs";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-ARxs/yqyVoIUWliJkINzitumF+64/5u3fbB0tHB5hPU=";
  };

  patches = [ ./cmake.patch ];

  nativeBuildInputs = [
    cmake
    rocm-cmake
  ];

  buildInputs = [ libxml2 ];
  cmakeFlags = [ "-DLLVM_TARGETS_TO_BUILD=AMDGPU;${llvmNativeTarget}" ];

  passthru.updateScript = rocmUpdateScript {
    name = finalAttrs.pname;
    owner = finalAttrs.src.owner;
    repo = finalAttrs.src.repo;
  };

  meta = with lib; {
    description = "Set of AMD-specific device-side language runtime libraries";
    homepage = "https://github.com/ROCm/ROCm-Device-Libs";
    license = licenses.ncsa;
    maintainers = with maintainers; [ lovesegfault ] ++ teams.rocm.members;
    platforms = platforms.linux;
    broken = versions.minor finalAttrs.version != versions.minor stdenv.cc.version || versionAtLeast finalAttrs.version "6.0.0";
  };
})
