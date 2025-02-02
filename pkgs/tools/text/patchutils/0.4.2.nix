{ callPackage, python3, ... } @ args:

callPackage ./generic.nix (args // {
  version = "0.4.2";
  sha256 = "sha256-iHWwll/jPeYriQ9s15O+f6/kGk5VLtv2QfH+1eu/Re0=";
  # for gitdiff
  extraBuildInputs = [ python3 ];
  patches = [ ./Revert-Fix-grepdiff-test.patch ];
})
