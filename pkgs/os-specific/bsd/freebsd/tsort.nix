{ mkDerivation, buildPackages, buildFreebsd, ... }:
mkDerivation {
  path = "usr.bin/tsort";
  extraPaths = ["sys/conf/newvers.sh" "sys/sys/param.h"];  # TODO this was added to fix a error which appeared but may be spurious
  makeFlags = [
    "STRIP=-s" # flag to install, not command
    "TESTSDIR=${builtins.placeholder "test"}"
  ];
  nativeBuildInputs = [
    buildPackages.bsdSetupHook buildFreebsd.freebsdSetupHook
    buildFreebsd.makeMinimal buildFreebsd.install buildPackages.mandoc buildPackages.groff  # TODO bmake???
  ];
  outputs = [ "out" "test" ];
}
