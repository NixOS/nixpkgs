{ callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  version = "2.2.14";
  sha256 = "1b2x3q1ach44qg07sh8wr7d8a10n36w5522drd3p35djbiwa3d9q";
  generation = "2_2";
  extraMeta.knownVulnerabilities = [
    # Fixed in 3.* but 2.* hasn't been released since
    "CVE-2020-17516"
  ];
})
