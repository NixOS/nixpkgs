{ lib, fetchFromGitHub, buildLinux, ... } @ args:

let
  # comments with variant added for update script
  # ./update-zen.py zen
  zenVariant = {
    version = "5.19.9"; #zen
    suffix = "zen1"; #zen
    sha256 = "1zwy5d7wzjxpzf9v13550zvfpkxhq7gck08zv9s94hwaz9h5xna3"; #zen
    isLqx = false;
  };
  # ./update-zen.py lqx
  lqxVariant = {
    version = "5.19.9"; #lqx
    suffix = "lqx1"; #lqx
    sha256 = "0jgl5dnbdcg7p2ix4lliif7l8pqvhnbl4ndxq64yyx78r7jrbfs2"; #lqx
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
