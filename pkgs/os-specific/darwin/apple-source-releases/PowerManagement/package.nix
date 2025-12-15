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
        '${iokitUser}/pwr_mgt.subproj/IOPMLibPrivate.h' \
        '${iokitUser}/pwr_mgt.subproj/IOPMAssertionCategories.h'
    '';
  };
in
mkAppleDerivation {
  releaseName = "PowerManagement";

  xcodeHash = "sha256-cjTF4dR6S55mLwp4GkQhkkNk9sMMKDc/5JTm46Z7/KE=";

  env.NIX_CFLAGS_COMPILE = "-I${privateHeaders}/include";

  meta.description = "Contains the Darwin caffeinate command";
}
