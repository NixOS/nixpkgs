{ # stdenv FIXME: Try changing back to this with a new ROCm release https://github.com/NixOS/nixpkgs/issues/271943
  gcc12Stdenv
, callPackage
, rocmUpdateScript
, wrapBintoolsWith
, overrideCC
, rocm-device-libs
, rocm-runtime
, rocm-thunk
, clr
}:

let
  ## Stage 1 ##
  # Projects
  llvm = callPackage ./stage-1/llvm.nix { inherit rocmUpdateScript; stdenv = gcc12Stdenv; };
  clang-unwrapped = callPackage ./stage-1/clang-unwrapped.nix { inherit rocmUpdateScript llvm; stdenv = gcc12Stdenv; };
  lld = callPackage ./stage-1/lld.nix { inherit rocmUpdateScript llvm; stdenv = gcc12Stdenv; };

  # Runtimes
  runtimes = callPackage ./stage-1/runtimes.nix { inherit rocmUpdateScript llvm; stdenv = gcc12Stdenv; };

  ## Stage 2 ##
  # Helpers
  bintools-unwrapped = callPackage ./stage-2/bintools-unwrapped.nix { inherit llvm lld; };
  bintools = wrapBintoolsWith { bintools = bintools-unwrapped; };
  rStdenv = callPackage ./stage-2/rstdenv.nix { inherit llvm clang-unwrapped lld runtimes bintools; stdenv = gcc12Stdenv; };
in rec {
  inherit
  llvm
  clang-unwrapped
  lld
  bintools;

  # Runtimes
  libc = callPackage ./stage-2/libc.nix { inherit rocmUpdateScript; stdenv = rStdenv; };
  libunwind = callPackage ./stage-2/libunwind.nix { inherit rocmUpdateScript; stdenv = rStdenv; };
  libcxxabi = callPackage ./stage-2/libcxxabi.nix { inherit rocmUpdateScript; stdenv = rStdenv; };
  libcxx = callPackage ./stage-2/libcxx.nix { inherit rocmUpdateScript; stdenv = rStdenv; };
  compiler-rt = callPackage ./stage-2/compiler-rt.nix { inherit rocmUpdateScript llvm; stdenv = rStdenv; };

  ## Stage 3 ##
  # Helpers
  clang = callPackage ./stage-3/clang.nix { inherit llvm lld clang-unwrapped bintools libc libunwind libcxxabi libcxx compiler-rt; stdenv = gcc12Stdenv; };
  rocmClangStdenv = overrideCC gcc12Stdenv clang;

  # Projects
  clang-tools-extra = callPackage ./stage-3/clang-tools-extra.nix { inherit rocmUpdateScript llvm clang-unwrapped; stdenv = rocmClangStdenv; };
  libclc = callPackage ./stage-3/libclc.nix { inherit rocmUpdateScript llvm clang; stdenv = rocmClangStdenv; };
  lldb = callPackage ./stage-3/lldb.nix { inherit rocmUpdateScript clang; stdenv = rocmClangStdenv; };
  mlir = callPackage ./stage-3/mlir.nix { inherit rocmUpdateScript clr; stdenv = rocmClangStdenv; };
  polly = callPackage ./stage-3/polly.nix { inherit rocmUpdateScript; stdenv = rocmClangStdenv; };
  flang = callPackage ./stage-3/flang.nix { inherit rocmUpdateScript clang-unwrapped mlir; stdenv = rocmClangStdenv; };
  openmp = callPackage ./stage-3/openmp.nix { inherit rocmUpdateScript llvm clang-unwrapped clang rocm-device-libs rocm-runtime rocm-thunk; stdenv = rocmClangStdenv; };

  # Runtimes
  pstl = callPackage ./stage-3/pstl.nix { inherit rocmUpdateScript; stdenv = rocmClangStdenv; };
}
