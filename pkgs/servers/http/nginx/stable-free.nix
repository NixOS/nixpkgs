{ callPackage, ... } @ args:

callPackage ./generic.nix args {
  pname = "freenginx";
  version = "1.24.0";
  freenginx = true;
  hash = "sha256-d6JUFje5KmIePudndsi3tAz21wfmm6U6lAKD4w/y9V0=";
}
