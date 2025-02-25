{
  lib,
  stdenv,
  cmake,
  ninja,
  libxml2,
  zlib,
  zstd,
  ncurses,
  rocm-llvm,
  python3,
}:

let
  llvmNativeTarget =
    if stdenv.hostPlatform.isx86_64 then
      "X86"
    else if stdenv.hostPlatform.isAarch64 then
      "AArch64"
    else
      throw "Unsupported ROCm LLVM platform";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "rocm-device-libs";
  # In-tree with ROCm LLVM
  inherit (rocm-llvm) version;
  src = rocm-llvm.src;

  postPatch = ''
    cd amd/device-libs
  '';

  patches = [ ./cmake.patch ];

  nativeBuildInputs = [
    cmake
    ninja
    python3
  ];

  buildInputs = [
    libxml2
    zlib
    zstd
    ncurses
    rocm-llvm
  ];

  cmakeFlags = [
    "-DCMAKE_RELEASE_TYPE=Release"
    "-DLLVM_TARGETS_TO_BUILD=AMDGPU;${llvmNativeTarget}"
  ];

  meta = with lib; {
    description = "Set of AMD-specific device-side language runtime libraries";
    homepage = "https://github.com/ROCm/ROCm-Device-Libs";
    license = licenses.ncsa;
    maintainers = with maintainers; [ lovesegfault ] ++ teams.rocm.members;
    platforms = platforms.linux;
  };
})
