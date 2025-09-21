{
  lib,
  stdenv,
  fetchpatch,
  cmake,
  ninja,
  libxml2,
  zlib,
  zstd,
  ncurses,
  rocm-merged-llvm,
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
stdenv.mkDerivation {
  pname = "rocm-device-libs";
  # In-tree with ROCm LLVM
  inherit (rocm-merged-llvm) version;
  src = rocm-merged-llvm.llvm-src;

  postPatch = ''
    cd amd/device-libs
  '';

  patches = [
    ./cmake.patch
    (fetchpatch {
      name = "cmake-4-compat-dont-set-cmp0053.patch";
      url = "https://github.com/ROCm/llvm-project/commit/a18cc4c7cb51f94182b6018c7c73acde1b8ebddb.patch";
      hash = "sha256-LNT7srxd4gXDAJ6lSsJXKnRQKSepkAbHeRNH+eZYIFk=";
    })
  ];

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
    rocm-merged-llvm
  ];

  cmakeFlags = [
    "-DCMAKE_RELEASE_TYPE=Release"
    "-DLLVM_TARGETS_TO_BUILD=AMDGPU;${llvmNativeTarget}"
  ];

  meta = with lib; {
    description = "Set of AMD-specific device-side language runtime libraries";
    homepage = "https://github.com/ROCm/ROCm-Device-Libs";
    license = licenses.ncsa;
    maintainers = with maintainers; [ lovesegfault ];
    teams = [ teams.rocm ];
    platforms = platforms.linux;
  };
}
