{ callPackage, ... }@args:

callPackage ./generic.nix (args // {
  version = "1.15.10";
  sha256 = "0g3wadbf9r730p0j5c0pnsmbmbrwvvnpyzhgbmsf9g2jplx78rdq";
})
