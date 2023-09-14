{ mkDerivation, buildPackages, pkgs }:
mkDerivation {
  path = "usr.bin/tsort";
  extraPaths = ["sys/conf/newvers.sh" "sys/sys/param.h"];  # TODO this was added to fix a error which appeared but may be spurious
  nativeBuildInputs = with buildPackages.freebsd; [
    pkgs.bsdSetupHook freebsdSetupHook
    makeMinimal install pkgs.mandoc pkgs.groff
  ];
}
