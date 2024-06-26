# A shell to get tooling for Nixpkgs development
#
# Note: We intentionally don't use Flakes here,
# because it would require copying all of Nixpkgs every time the shell is refreshed.
# See https://github.com/NixOS/nix/pull/6530 for the future
{
  system ? builtins.currentSystem,
}:
let
  pinnedNixpkgs = builtins.fromJSON (builtins.readFile ci/pinned-nixpkgs.json);

  nixpkgs = fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/${pinnedNixpkgs.rev}.tar.gz";
    sha256 = pinnedNixpkgs.sha256;
  };

  pkgs = import nixpkgs {
    inherit system;
    config = {};
    overlays = [];
  };
in
pkgs.mkShellNoCC {
  packages = [
    # The default formatter for Nix code
    # https://github.com/NixOS/nixfmt
    pkgs.nixfmt-rfc-style
  ];
}
