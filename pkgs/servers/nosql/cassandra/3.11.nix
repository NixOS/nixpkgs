{ callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  version = "3.11.10";
  sha256 = "1wcv0drhb765fda6kkpsxsyfdv4cqf7nqfwc4bimh4c4djap5rxv";
  generation = "3_11";
})
