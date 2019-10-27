{ callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  version = "2.1.20";
  sha256 = "0ik7a4jg3s3xnyrj1sa0rvbh066fv1y2202l7cv6nbca72pgyl6a";
})
