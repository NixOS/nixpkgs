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
  nixpkgs ? (
    # On 26.05 we need a CI-pinned Nixpkgs revision that supports x86_64-darwin.
    # TODO: remove after 26.05 support ends.
    if system == "x86_64-darwin" && (builtins.readFile ./.version) == "26.05" then
      let
        pinned = (builtins.fromJSON (builtins.readFile ./ci/pinned.json)).pins;
        warn = builtins.warn or (import ./lib).warn;

        inherit (pinned."nixpkgs-26.05-darwin")
          url
          hash
          revision
          branch
          ;

        withWarning = warn (toString [
          "The currently pinned Nixpkgs (${pinned.nixpkgs.revision}) does not support ${system},"
          "using revision (${revision}) from ${branch}."
          "You may experience some differences to CI."
        ]);
      in
      withWarning fetchTarball {
        inherit url;
        sha256 = hash;
      }
    else
      null
  ),
}:
let
  inherit (import ./ci { inherit nixpkgs system; }) pkgs fmt;

  # For `nix-shell -A hello`
  curPkgs = removeAttrs (import ./. { inherit system; }) [
    # Although this is what anyone may expect from a `_type = "pkgs"`,
    # this file is intended to produce a shell in the first place,
    # and a `_type` tag could confuse some code.
    "_type"
  ];
in
curPkgs
// pkgs.mkShellNoCC {
  packages = [
    # Helper to review Nixpkgs PRs
    # See CONTRIBUTING.md
    pkgs.nixpkgs-reviewFull
    # Command-line utility for working with GitHub
    # Used by nixpkgs-review to fetch eval results
    pkgs.gh
    # treefmt wrapper
    fmt.pkg
  ];
}
// {
  formatter = fmt.pkg;
}
