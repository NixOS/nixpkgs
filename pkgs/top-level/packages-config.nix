# Used in the generation of package search database.
{
  # Ensures no aliases are in the results.
  allowAliases = false;

  # Enable recursion into attribute sets that nix-env normally doesn't look into
  # so that we can get a more complete picture of the available packages for the
  # purposes of the index.
  packageOverrides = super: with super; lib.mapAttrs (_: set: recurseIntoAttrs set) {
    inherit (super)
      apacheHttpdPackages
      atomPackages
      fdbPackages
      fusePackages
      gns3Packages
      idrisPackages
      nodePackages
      nodePackages_latest
      platformioPackages
      quicklispPackagesClisp
      quicklispPackagesSBCL
      rPackages
      roundcubePlugins
      sconsPackages
      sourceHanPackages
      steamPackages
      ut2004Packages
      zabbix40
      zabbix50
      zabbix60
      zeroadPackages
    ;

    haskellPackages = super.haskellPackages // {
      # mesos, which this depends on, has been removed from nixpkgs. We are keeping
      # the error message for now, so users will get an error message they can make
      # sense of, but need to work around it here.
      # TODO(@sternenseemann): remove this after branch-off of 22.05, along with the
      # override in configuration-nix.nix
      hs-mesos = null;
    };

    # Make sure haskell.compiler is included, so alternative GHC versions show up,
    # but don't add haskell.packages.* since they contain the same packages (at
    # least by name) as haskellPackages.
    haskell = super.haskell // {
      compiler = recurseIntoAttrs super.haskell.compiler;
    };
  };
}
