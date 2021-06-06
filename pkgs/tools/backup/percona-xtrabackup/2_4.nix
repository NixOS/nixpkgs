{ callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  version = "2.4.20";
  sha256 = "0awdpkcgvx2aq7pwxy8jyzkin6cyrrh3d576x9ldm851kis9n5ii";
})
