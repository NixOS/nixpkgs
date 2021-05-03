{ lib, stdenv, buildLinux, fetchFromGitHub, ... } @ args:

let
  version = "5.11.16";
  suffix = "xanmod1-cacule";
in
  buildLinux (args // rec {
    modDirVersion = "${version}-${suffix}";
    inherit version;

    src = fetchFromGitHub {
      owner = "xanmod";
      repo = "linux";
      rev = modDirVersion;
      sha256 = "sha256-sK2DGJsmKP/gvPyT8HWjPa21OOXydMhGjJzrOkPo71Q=";
      extraPostFetch = ''
        rm $out/.config
      '';
    };

    extraMeta = {
      branch = "5.11";
      maintainers = with lib.maintainers; [ fortuneteller2k ];
      description = "Built with custom settings and new features built to provide a stable, responsive and smooth desktop experience";
      broken = stdenv.hostPlatform.isAarch64;
    };
  } // (args.argsOverride or { }))
