{
  symlinkJoin,
  linkFarm,
  clr,
  hipblas,
  rocblas,
  rocsolver,
  rocsparse,
  rocm-device-libs,
  rocm-smi,
  llvm,
}:
symlinkJoin {
  name = "rocm-path-${clr.version}";
  paths = [
    clr
    hipblas
    rocblas
    rocsolver
    rocsparse
    rocm-device-libs
    rocm-smi
    (linkFarm "rocm-llvm-subdir" { llvm = llvm.clang; })
  ];
}
