{ lib, fetchFromGitHub, buildLinux, ... } @ args:

let
  zenVariant = {
    version = "5.18.5";
    suffix = "zen1";
    sha256 = "sha256-q6a8Wyzs6GNQ39mV+q/9N6yo/kXS9ZH+QTfGka42gk4=";
    isLqx = false;
  };
  lqxVariant = {
    version = "5.15.16";
    suffix = "lqx2";
    sha256 = "sha256-kdT/hiASZ72pkS0Igta0KT0GWTgDRjxBnd5CQ0eonfg=";
    isLqx = true;
  };
  zenKernelsFor = { version, suffix, sha256, isLqx }: buildLinux (args // {
    inherit version;
    modDirVersion = "${lib.concatStringsSep "." (lib.take 3 (lib.splitVersion version ++ [ "0" "0" ]))}-${suffix}";
    isZen = true;

    src = fetchFromGitHub {
      owner = "zen-kernel";
      repo = "zen-kernel";
      rev = "v${version}-${suffix}";
      inherit sha256;
    };

    extraMeta = {
      branch = lib.versions.majorMinor version + "/master";
      maintainers = with lib.maintainers; [ atemu andresilva psydvl ];
      description = "Built using the best configuration and kernel sources for desktop, multimedia, and gaming workloads." +
        lib.optionalString isLqx " (Same as linux_zen but less aggressive release schedule)";
    };

  } // (args.argsOverride or { }));
in
{
  zen = zenKernelsFor zenVariant;
  lqx = zenKernelsFor lqxVariant;
}
