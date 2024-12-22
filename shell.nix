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
{
  system ? builtins.currentSystem,
  nixpkgs ? null,
}:
let
  inherit (import ./ci { inherit nixpkgs system; }) pkgs;

  # For `nix-shell -A hello`
  curPkgs = builtins.removeAttrs (import ./. { inherit system; }) [
    # Although this is what anyone may expect from a `_type = "pkgs"`,
    # this file is intended to produce a shell in the first place,
    # and a `_type` tag could confuse some code.
    "_type"
  ];
in
curPkgs
// pkgs.mkShellNoCC {
  packages = with pkgs; [
    # The default formatter for Nix code
    # See https://github.com/NixOS/nixfmt
    nixfmt-rfc-style
    # Helper to review Nixpkgs PRs
    # See CONTRIBUTING.md
    nixpkgs-review
  ];
}
