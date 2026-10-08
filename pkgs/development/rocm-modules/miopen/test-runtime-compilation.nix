{
  lib,
  makeImpureTest,
  writableTmpDirAsHomeHook,
  miopen,
  clr,
  rocm-smi,
  name,
  testScript,
}:

makeImpureTest {
  inherit name;
  testedPackage = "rocmPackages.miopen";

  sandboxPaths = [
    "/sys"
    "/dev/dri"
    "/dev/kfd"
  ];

  nativeBuildInputs = [
    writableTmpDirAsHomeHook
    miopen
    clr
    rocm-smi
  ];

  testScript = ''
    rocm-smi
    ${testScript}
  '';

  meta = {
    teams = [ lib.teams.rocm ];
  };
}
