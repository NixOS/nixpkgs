# To update package version:
#   1. Change version string in node-package.json and this file
#   2. Run `./generate.sh` to rebuild node dependencies with node2nix
#   3. Build this package `nix-build -A psitransfer`
#   4. Profit

{ stdenv
, pkgs
, lib
, nodejs_14
, fetchzip
}:

let
  # nodejs_16 fails with ENOTCACHED
  nodejs = nodejs_14;

  nodePackages = import ./node-composition.nix {
    inherit pkgs nodejs;
    inherit (stdenv.hostPlatform) system;
  };

  psitransfer = lib.head (lib.attrValues nodePackages);

  combined = psitransfer.override rec {
    # version is not defined in source package.json
    # version must also be maintained in node-packages.json for node2nix
    version = "2.0.1";

    # override node2nix package src to pull pre-built release of same version
    src = fetchzip {
      url = "https://github.com/psi-4ward/psitransfer/releases/download/v${version}/psitransfer-v${version}.tar.gz";
      sha256 = "mfldWTVmfcIRa+1g8YDnQqem5YmrFRfCxJoitWcXvns=";
      stripRoot = false;
    };

    meta = with lib; {
      homepage = "https://github.com/psi-4ward/psitransfer";
      description = "Simple open source self-hosted file sharing solution";
      license = licenses.bsd2;
      maintainers = with maintainers; [ hyshka ];
    };
  };
in
  combined
