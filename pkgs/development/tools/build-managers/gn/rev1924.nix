{ callPackage, ... } @ args:

callPackage ./generic.nix args {
  rev = "24e2f7df92641de0351a96096fb2c490b2436bb8";
  revNum = "1924"; # git describe HEAD --match initial-commit | cut -d- -f3
  version = "2021-08-08";
  sha256 = "1lwkyhfhw0zd7daqz466n7x5cddf0danr799h4jg3s0yvd4galjl";
}
