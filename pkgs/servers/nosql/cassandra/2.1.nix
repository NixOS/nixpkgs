{ callPackage, ... } @ args:

callPackage ./generic.nix (
  args
  // builtins.fromJSON (builtins.readFile ./2.1.json)
  // {
    generation = "2_1";
    extraMeta.knownVulnerabilities = [
      # Fixed in 3.* but 2.* hasn't been released since
      "CVE-2020-17516"
    ];
  })
