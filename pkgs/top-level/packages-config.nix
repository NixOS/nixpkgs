# Used in the generation of package search database.
{
  # Ensures no aliases are in the results.
  allowAliases = false;

  # Enable recursion into attribute sets that nix-env normally doesn't look into
  # so that we can get a more complete picture of the available packages for the
  # purposes of the index.
  packageOverrides = super:
  let
    inherit (super) lib;
    recurseIntoAttrs = sets:
      lib.genAttrs
        # Recursively filter sets delimited by dots
        (builtins.filter (set: builtins.foldl' (super: attr: if builtins.hasAttr attr super then super.${attr} else { }) super (lib.splitString "." set) != { }) sets)
        (set: super.recurseIntoAttrs (builtins.foldl' (super: attr: super.${attr}) super (lib.splitString "." set)));
  in recurseIntoAttrs [
    "roundcubePlugins"
    "emscriptenfastcompPackages"
    "fdbPackages"
    "nodePackages_latest"
    "nodePackages"
    "platformioPackages"
    "haskellPackages"
    "idrisPackages"
    "sconsPackages"
    "gns3Packages"
    "quicklispPackagesClisp"
    "quicklispPackagesSBCL"
    "rPackages"
    "apacheHttpdPackages_2_4"
    "zabbix50"
    "zabbix40"
    "zabbix30"
    "fusePackages"
    "nvidiaPackages"
    "sourceHanPackages"
    "atomPackages"
    "emacs26.pkgs"
    "emacs27.pkgs"
    "steamPackages"
    "ut2004Packages"
    "zeroadPackages"
  ];
}
