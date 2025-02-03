# A shell to get tooling for Nixpkgs development
#
# Note: We intentionally don't use Flakes here,
# because every time you change any file and do another `nix develop`,
# it would create another copy of the entire ~500MB tree in the store.
# See https://github.com/NixOS/nix/pull/6530 for the future
#
# Note: We use a pinned Nixpkgs so that the tools are readily available even
# when making changes that would otherwise require a new build of those tools.
# If you'd like to test out changes to the tools themselves, you can pass
#
#     nix-shell --arg nixpkgs ./.
#
let
  pinnedNixpkgs = builtins.fromJSON (builtins.readFile ci/pinned-nixpkgs.json);
in
{
  system ? builtins.currentSystem,

  nixpkgs ? fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/${pinnedNixpkgs.rev}.tar.gz";
    sha256 = pinnedNixpkgs.sha256;
  },
}:
let
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
