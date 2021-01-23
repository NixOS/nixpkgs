{ callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  version = "3.0.23";
  sha256 = "0cbia20bggq85q2p6gsybw045qdfqxd5xv8ihppq1hwl21sb2klz";
  generation = "3_0";
})
