{ callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  version = "2.2.9";
  sha256 = "1wc2l8l7i43r0yc6qqi3wj4pm0969kjkh2pgx80wglzxm7275hv5";
})
