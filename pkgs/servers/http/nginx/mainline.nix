{ callPackage, ... }@args:

callPackage ./generic.nix (args // {
  version = "1.17.2";
  sha256 = "1v39gslwbvpfhqqv74q0lkfrhrwsp59xc8pwhvxns7af8s3kccsy";
})
