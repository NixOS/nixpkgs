# Used in the generation of package search database.
{
  # Ensures no aliases are in the results.
  allowAliases = false;
  allowVariants = false;

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
    };
}
