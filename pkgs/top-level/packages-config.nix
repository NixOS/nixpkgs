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
    lib.mapAttrs (_: set: recurseIntoAttrs set) {
      inherit (super)
        agdaPackages
        apacheHttpdPackages
        fdbPackages
        fusePackages
        gns3Packages
        haskellPackages
        idrisPackages
        nodePackages
        nodePackages_latest
        platformioPackages
        rPackages
        roundcubePlugins
        sourceHanPackages
        zabbix50
        zabbix60
        zeroadPackages
        ;

      # Make sure haskell.compiler is included, so alternative GHC versions show up,
      # but don't add haskell.packages.* since they contain the same packages (at
      # least by name) as haskellPackages.
      haskell = super.haskell // {
        compiler = recurseIntoAttrs super.haskell.compiler;
      };

      # minimal-bootstrap packages aren't used for anything but bootstrapping our
      # stdenv. They should not be used for any other purpose and therefore not
      # show up in search results or repository tracking services that consume our
      # packages.json https://github.com/NixOS/nixpkgs/issues/244966
      minimal-bootstrap = { };
    };
}
