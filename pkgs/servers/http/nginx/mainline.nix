{ callPackage, ... }@args:

callPackage ./generic.nix (args // {
  version = "1.11.13";
  sha256 = "1lqm2ixld5b55s4i1yy5337c6ifp7jzjfsm51z49hagdz0g602rn";
})
