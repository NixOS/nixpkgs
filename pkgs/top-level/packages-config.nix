# Used in the generation of package search database.
{
  # Ensures no aliases are in the results.
  allowAliases = false;

  # Enable recursion into attribute sets that nix-env normally doesn't look into
  # so that we can get a more complete picture of the available packages for the
  # purposes of the index.
  packageOverrides =
    super:
    with super;
    lib.mapAttrs (_: set: lib.recurseIntoAttrs set) {
      inherit (super)
        rPackages
        sourceHanPackages
        ;

      # emacsPackages is an alias for emacs.pkgs
      # Re-introduce emacsPackages here so that emacs.pkgs can be searched.
      emacsPackages = emacs.pkgs;

      # minimal-bootstrap packages aren't used for anything but bootstrapping our
      # stdenv. They should not be used for any other purpose and therefore not
      # show up in search results or repository tracking services that consume our
      # packages.json https://github.com/NixOS/nixpkgs/issues/244966
      minimal-bootstrap = { };

      # This makes it so that tests are not appering on search.nixos.org
      tests = { };
    };
}
