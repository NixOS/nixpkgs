{ callPackage, ... }@args:

callPackage ./generic.nix (args // {
  version = "1.15.1";
  sha256 = "0q2lkpnfqf74p22vrcldx0gcnss3is7rnp54fgpvhcpqsxc6h867";
})
