{ callPackage, ... }@args:

callPackage ./generic.nix (args // {
  version = "1.15.12";
  sha256 = "1giavdph0jqhywdkj4650s5qhz6qfd6nrv74k9q005yy2ym90nrx";
})
