{
  lib,
  stdenv,
  fetchFromGitHub,
  rocmUpdateScript,
  cmake,
  rocm-cmake,
  rocm-device-libs,
  libxml2,
}:

let
  llvmNativeTarget =
    if stdenv.isx86_64 then
      "X86"
    else if stdenv.isAarch64 then
      "AArch64"
    else
      throw "Unsupported ROCm LLVM platform";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "rocm-comgr";
  version = "6.0.2";

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "ROCm-CompilerSupport";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-9HuNU/k+kPJMlzqOTM20gm6SAOWJe9tpAZXEj4erdmI=";
  };

  sourceRoot = "${finalAttrs.src.name}/lib/comgr";

  nativeBuildInputs = [
    cmake
    rocm-cmake
  ];

  buildInputs = [
    rocm-device-libs
    libxml2
  ];

  cmakeFlags = [ "-DLLVM_TARGETS_TO_BUILD=AMDGPU;X86" ];

  passthru.updateScript = rocmUpdateScript {
    name = finalAttrs.pname;
    owner = finalAttrs.src.owner;
    repo = finalAttrs.src.repo;
  };

  meta = with lib; {
    description = "APIs for compiling and inspecting AMDGPU code objects";
    homepage = "https://github.com/ROCm/ROCm-CompilerSupport/tree/amd-stg-open/lib/comgr";
    license = licenses.ncsa;
    maintainers = with maintainers; [ lovesegfault ] ++ teams.rocm.members;
    platforms = platforms.linux;
    broken =
      versions.minor finalAttrs.version != versions.minor stdenv.cc.version
      || versionAtLeast finalAttrs.version "7.0.0";
  };
})
