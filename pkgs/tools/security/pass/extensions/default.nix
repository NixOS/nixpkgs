{ pkgs, ... }:

with pkgs;

{
  pass-audit = callPackage ./audit.nix {
    pythonPackages = python3Packages;
  };
  pass-import = callPackage ./import.nix {
    pythonPackages = python3Packages;
  };
  pass-otp = callPackage ./otp.nix {};
  pass-tomb = callPackage ./tomb.nix {};
  pass-update = callPackage ./update.nix {};
  pass-genphrase = callPackage ./genphrase.nix {};
}
