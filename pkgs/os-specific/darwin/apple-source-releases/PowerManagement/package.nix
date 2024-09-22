{
  lib,
  apple-sdk,
  mkAppleDerivation,
  stdenvNoCC,
}:

let
  iokitUser = apple-sdk.sourceRelease "IOKitUser";

  privateHeaders = stdenvNoCC.mkDerivation {
    name = "file_cmds-deps-private-headers";

    buildCommand = ''
      install -D -t "$out/include/IOKit/pwr_mgt" \
        '${iokitUser}/pwr_mgt.subproj/IOPMLibPrivate.h'
    '';
  };
in
mkAppleDerivation {
  releaseName = "PowerManagement";

  xcodeHash = "sha256-Zx3DwooXyY81jve5tSxmT13NKAsnsn6D2PRelh65Q7Q=";

  env.NIX_CFLAGS_COMPILE = "-I${privateHeaders}/include";

  meta.description = "Contains the Darwin caffeinate command";
}
