{pkgs, config, ...}:

###### interface
let
  inherit (pkgs.lib) mkOption mkIf;

  options = {
    installer = {
      nixpkgsURL = mkOption {
        default = "";
        example = http://nixos.org/releases/nix/nixpkgs-0.11pre7577;
        description = "
          URL of the Nixpkgs distribution to use when building the
          installation CD.
        ";
      };

      manifests = mkOption {
        default = [http://nixos.org/releases/nixpkgs/channels/nixpkgs-unstable/MANIFEST];
        example =
          [ http://nixos.org/releases/nixpkgs/channels/nixpkgs-unstable/MANIFEST
            http://nixos.org/releases/nixpkgs/channels/nixpkgs-stable/MANIFEST
          ];
        description = "
          URLs of manifests to be downloaded when you run
          <command>nixos-rebuild</command> to speed up builds.
        ";
      };
    };
  };


in

###### implementation

{
  require = [
    options
  ];
}
