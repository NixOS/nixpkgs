{ lib, fetchFromGitHub, buildLinux, ... } @ args:

let
  # comments with variant added for update script
  # ./update-zen.py zen
  zenVariant = {
    version = "5.18.14"; #zen
    suffix = "zen1"; #zen
    sha256 = "019v1ryzg5fq6xwvb8anmfxh0zpy8wd0qfiszfqxkqw7cnqc6wf1"; #zen
    isLqx = false;
  };
  # ./update-zen.py lqx
  lqxVariant = {
    version = "5.18.14"; #lqx
    suffix = "lqx2"; #lqx
    sha256 = "0g45y0rhbwpz12cbrh486vqxpzwdm0w5j7h3nxr0dr2ij8qzrr5p"; #lqx
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

    passthru.updateScript = [ ./update-zen.py (if isLqx then "lqx" else "zen") ];

    extraMeta = {
      branch = lib.versions.majorMinor version + "/master";
      maintainers = with lib.maintainers; [ andresilva pedrohlc ];
      description = "Built using the best configuration and kernel sources for desktop, multimedia, and gaming workloads." +
        lib.optionalString isLqx " (Same as linux_zen but less aggressive release schedule)";
    };

  } // (args.argsOverride or { }));
in
{
  zen = zenKernelsFor zenVariant;
  lqx = zenKernelsFor lqxVariant;
}
