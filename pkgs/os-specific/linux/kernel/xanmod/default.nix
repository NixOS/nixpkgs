{
  lib,
  stdenv,
  fetchFromGitLab,
  buildLinux,
  variant,
  ...
}@args:

let
  # These names are how they are designated in https://xanmod.org.

  # NOTE: When updating these, please also take a look at the changes done to
  # kernel config in the xanmod version commit at
  # https://gitlab.com/xanmod/linux/-/blob/${version}/CONFIGS/x86_64/config
  # where version is majorMinor, e.g. 6.18 or 7.2
  variants = {
    # ./update-xanmod.sh lts
    lts = {
      version = "6.18.60";
      hash = "sha256-Cr00tBcTVqTccLQ3Ptxx0AvxGs7vvfFT70syY+u+uUc=";
      isLTS = true;
    };
    # ./update-xanmod.sh main
    main = {
      version = "7.2.14";
      hash = "sha256-G1c+7IOkTr+TiMdLo3eIRboiSaWDij0dVb61clH40vY=";
    };
  };

  # nixpkgs-update: no auto update

  xanmodKernelFor =
    {
      version,
      suffix ? "xanmod1",
      hash,
      isLTS ? false,
    }:
    buildLinux (
      args
      // rec {
        inherit version;
        pname = "linux-xanmod";
        modDirVersion = lib.versions.pad 3 "${version}-${suffix}";

        src = fetchFromGitLab {
          owner = "xanmod";
          repo = "linux";
          rev = modDirVersion;
          inherit hash;
        };

        structuredExtraConfig = import ./structured-extra-config.nix {
          inherit
            lib
            version
            ;
        };

        extraPassthru.updateScript = {
          command = [
            ./update.sh
            variant
          ];
          supportedFeatures = [
            "commit"
          ];
        };

        inherit isLTS;

        extraMeta = {
          branch = lib.versions.majorMinor version;
          maintainers = with lib.maintainers; [
            moni
            lovesegfault
            atemu
            zzzsy
            eljamm
          ];
          teams = [ ];
          description = "Built with custom settings and new features built to provide a stable, responsive and smooth desktop experience";
          broken = stdenv.hostPlatform.isAarch64;
        };
      }
      // (args.argsOverride or { })
    );
in
xanmodKernelFor variants.${variant}
