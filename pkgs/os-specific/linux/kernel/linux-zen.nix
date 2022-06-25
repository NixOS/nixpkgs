{ lib, fetchFromGitHub, buildLinux, ... } @ args:

let
  # having the full version string here makes it easier to update
  modDirVersion = "5.18.5-zen1";
  parts = lib.splitString "-" modDirVersion;
  version = lib.elemAt parts 0;
  suffix = lib.elemAt parts 1;

  numbers = lib.splitString "." version;
  branch = "${lib.elemAt numbers 0}.${lib.elemAt numbers 1}";
  rev = if ((lib.elemAt numbers 2) == "0") then "v${branch}-${suffix}" else "v${modDirVersion}";
in

buildLinux (args // {
  inherit version modDirVersion;
  isZen = true;

  src = fetchFromGitHub {
    owner = "zen-kernel";
    repo = "zen-kernel";
    inherit rev;
    sha256 = "sha256-q6a8Wyzs6GNQ39mV+q/9N6yo/kXS9ZH+QTfGka42gk4=";
  };

  structuredExtraConfig = with lib.kernel; {
    ZEN_INTERACTIVE = yes;
    # TODO: Remove once #175433 reaches master
    # https://nixpk.gs/pr-tracker.html?pr=175433
    WERROR = no;
  };

  extraMeta = {
    inherit branch;
    maintainers = with lib.maintainers; [ atemu andresilva ];
    description = "Built using the best configuration and kernel sources for desktop, multimedia, and gaming workloads.";
  };

} // (args.argsOverride or { }))
