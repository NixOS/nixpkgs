{
  lib,
  makeImpureTest,
  opencl-cts,
  clr,
}:

makeImpureTest {
  name = "opencl-cts";
  testedPackage = "rocmPackages.clr";

  sandboxPaths = [
    "/sys"
    "/dev/dri"
    "/dev/kfd"
  ];

  nativeBuildInputs = [ opencl-cts ];
  OCL_ICD_VENDORS = "${clr.icd}/etc/OpenCL/vendors";

  testScript = ''
    test_basic arraycopy arrayreadwrite astype barrier vector_swizzle work_item_functions
  '';

  meta = {
    teams = [ lib.teams.rocm ];
  };
}
