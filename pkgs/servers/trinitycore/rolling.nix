{ callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  version = "TDB1017.23101";
  commit = "f774c4e855b372676190279b2bc1ba12ed15f028";
  hash = "sha256-fqDsF6owdy6FRSS8BF9Z9ShrorM0dF5ilLBF18ghtt0=";
})
