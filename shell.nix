# A shell to get tooling for Nixpkgs development
#
# Note: We intentionally don't use Flakes here,
# because every time you change any file and do another `nix develop`,
# it would create another copy of the entire ~500MB tree in the store.
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
    config = { };
    overlays = [ ];
  };
in
pkgs.mkShellNoCC {
  packages = with pkgs; [
    # The default formatter for Nix code
    # See https://github.com/NixOS/nixfmt
    nixfmt-rfc-style
    # Helper to review Nixpkgs PRs
    # See CONTRIBUTING.md
    nixpkgs-review
  ];
}
