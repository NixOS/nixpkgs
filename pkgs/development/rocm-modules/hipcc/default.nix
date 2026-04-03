{
  lib,
  stdenv,
  llvm,
  cmake,
  lsb-release,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hipcc";
  # In-tree with ROCm LLVM
  inherit (llvm.llvm) version;
  src = llvm.llvm.monorepoSrc;
  sourceRoot = "${finalAttrs.src.name}/amd/hipcc";
  strictDeps = true;

  nativeBuildInputs = [
    llvm.rocm-toolchain
    cmake
  ];

  buildInputs = [
    llvm.clang-unwrapped
  ];

  postPatch = ''
    substituteInPlace src/hipBin_amd.h \
      --replace-fail "/usr/bin/lsb_release" "${lsb-release}/bin/lsb_release"
  '';

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
  ];
  postInstall = ''
    rm -r $out/hip/bin
    ln -s $out/bin $out/hip/bin
  '';

  meta = {
    description = "Compiler driver utility that calls clang or nvcc";
    homepage = "https://github.com/ROCm/HIPCC";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ lovesegfault ];
    teams = [ lib.teams.rocm ];
    platforms = lib.platforms.linux;
  };
})
