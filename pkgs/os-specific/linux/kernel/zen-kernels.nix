{ lib, fetchFromGitHub, buildLinux, ... } @ args:

let
  # comments with variant added for update script
  # ./update-zen.py zen
  zenVariant = {
    version = "6.4.1"; #zen
    suffix = "zen1"; #zen
    sha256 = "05a3dplzz6vy5gjz9yd1hz7n4xf3mlr2q112kf3yabg8k8izqnys"; #zen
    isLqx = false;
  };
  # ./update-zen.py lqx
  lqxVariant = {
    version = "6.3.11"; #lqx
    suffix = "lqx2"; #lqx
    sha256 = "0hpzafw2zwy25ss4cwj6mm8pr1nnv680m8bfcal29f7gaxbm96k8"; #lqx
    isLqx = true;
  };
  zenKernelsFor = { version, suffix, sha256, isLqx }: buildLinux (args // {
    inherit version;
    modDirVersion = lib.versions.pad 3 "${version}-${suffix}";
    isZen = true;

    src = fetchFromGitHub {
      owner = "zen-kernel";
      repo = "zen-kernel";
      rev = "v${version}-${suffix}";
      inherit sha256;
    };

    passthru.updateScript = [ ./update-zen.py (if isLqx then "lqx" else "zen") ];

    extraMeta = {
      branch = lib.versions.majorMinor version + "/master";
      maintainers = with lib.maintainers; [ ];
      description = "Built using the best configuration and kernel sources for desktop, multimedia, and gaming workloads." +
        lib.optionalString isLqx " (Same as linux_zen but less aggressive release schedule)";
    };

  } // (args.argsOverride or { }));
in
{
  zen = zenKernelsFor zenVariant;
  lqx = zenKernelsFor lqxVariant;
}
