{
  mkAppleDerivation,
  sourceRelease,
  stdenvNoCC,
}:

let
  iokitUser = sourceRelease "IOKitUser";

  privateHeaders = stdenvNoCC.mkDerivation {
    name = "file_cmds-deps-private-headers";

    buildCommand = ''
      install -D -t "$out/include/IOKit/pwr_mgt" \
        '${iokitUser}/pwr_mgt.subproj/IOPMLibPrivate.h' \
        '${iokitUser}/pwr_mgt.subproj/IOPMAssertionCategories.h'
    '';
  };
in
mkAppleDerivation {
  releaseName = "PowerManagement";

  xcodeHash = "sha256-06rCxqBUrYqBY7BDZ6s/vSoviUAmIbsQP1pfrvR2Gpk=";

  env.NIX_CFLAGS_COMPILE = "-I${privateHeaders}/include";

  meta.description = "Contains the Darwin caffeinate command";
}
