{ callPackage, ... } @ args:

callPackage ./generic.nix (
  args
  // builtins.fromJSON (builtins.readFile ./2.2.json)
  // {
    generation = "2_2";
    extraMeta.knownVulnerabilities = [
      # Fixed in 3.* but 2.* hasn't been released since
      "CVE-2020-17516"
    ];
  })
