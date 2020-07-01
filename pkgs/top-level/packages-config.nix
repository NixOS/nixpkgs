# Used in the generation of package search database.
{
  # Ensures no aliases are in the results.
  allowAliases = false;

  # Enable recursion into attribute sets that nix-env normally doesn't look into
  # so that we can get a more complete picture of the available packages for the
  # purposes of the index.
  packageOverrides = super: {
    haskellPackages = super.recurseIntoAttrs super.haskellPackages;
    rPackages = super.recurseIntoAttrs super.rPackages;
  };
}
