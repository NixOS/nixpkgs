{ callPackage }:

{
  libDER = callPackage ./libDER.nix { };
  sandbox = callPackage ./sandbox.nix { };
  simd = callPackage ./simd.nix { };
  utmp = callPackage ./utmp.nix { };
  xpc = callPackage ./xpc.nix { };
  Xplugin = callPackage ./Xplugin.nix { };
}
