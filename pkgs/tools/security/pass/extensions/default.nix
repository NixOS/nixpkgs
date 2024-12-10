{ pkgs, ... }:

let
  inherit (pkgs) callPackage python3Packages;
in

{
  pass-audit = callPackage ./audit {
    pythonPackages = python3Packages;
  };
  pass-checkup = callPackage ./checkup.nix { };
  pass-import = callPackage ./import.nix { };
  pass-otp = callPackage ./otp.nix { };
  pass-tomb = callPackage ./tomb.nix { };
  pass-update = callPackage ./update.nix { };
  pass-genphrase = callPackage ./genphrase.nix { };
  pass-file = callPackage ./file.nix { };
}
