{ mkDerivation, buildPackages, buildFreebsd, lib, hostVersion, ... }:
mkDerivation {
  path = "usr.bin/tsort";
  extraPaths = [];
  makeFlags = [
    "STRIP=-s" # flag to install, not command
  ] ++ lib.optionals (hostVersion == "14.0") [
    "TESTSDIR=${builtins.placeholder "test"}"
  ];
  nativeBuildInputs = [
    buildPackages.bsdSetupHook buildFreebsd.freebsdSetupHook
    buildFreebsd.bmakeMinimal buildFreebsd.install buildPackages.mandoc buildPackages.groff  # TODO bmake???
  ];
  outputs = [ "out" ] ++ lib.optionals (hostVersion == "14.0") [ "test" ];
}
