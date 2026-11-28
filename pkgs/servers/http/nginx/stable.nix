{ callPackage, ... }@args:

callPackage ./generic.nix args {
  version = "1.30.8";
  hash = "sha256-+GcxStoy5xe5SZMIWWVsSKctxmV67FmNtYry+YpA4cE=";
  flavor = "stable";
}
