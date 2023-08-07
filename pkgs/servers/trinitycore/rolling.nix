{ callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  version = "TDB1007.23041";
  commit = "1b588502e3afddb2312514d4ac9d87a9640e7dfd";
  sha256 = "sha256-fqDsF6owdy6FRSS8BF9Z9ShrorM0dF5ilLBF18ghtt0=";
})
