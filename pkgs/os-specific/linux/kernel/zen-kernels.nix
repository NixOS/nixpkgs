{ lib, fetchFromGitHub, buildLinux, ... } @ args:

let
  # comments with variant added for update script
  # ./update-zen.py zen
  zenVariant = {
    version = "6.2.5"; #zen
    suffix = "zen1"; #zen
    sha256 = "0ilkb8rqww30nl4sa01jy97s8gs67y96qwf9r0z0z7xy3w05s8bl"; #zen
    isLqx = false;
  };
  # ./update-zen.py lqx
  lqxVariant = {
    version = "6.1.18"; #lqx
    suffix = "lqx1"; #lqx
    sha256 = "1gyjy01ys74apa65abgvxcj0y51vf5ixampyj3jd8lxzn4vvkih6"; #lqx
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
      maintainers = with lib.maintainers; [ pedrohlc ];
      description = "Built using the best configuration and kernel sources for desktop, multimedia, and gaming workloads." +
        lib.optionalString isLqx " (Same as linux_zen but less aggressive release schedule)";
    };

  } // (args.argsOverride or { }));
in
{
  zen = zenKernelsFor zenVariant;
  lqx = zenKernelsFor lqxVariant;
}
