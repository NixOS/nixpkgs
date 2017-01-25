{ callPackage, ... }@args:

callPackage ./generic.nix (args // {
  version = "1.11.8";
  sha256 = "0d3bcrgj2ykky2yk06y0ihv6832s30mqzcfwq8a560brbmqz7bjk";
})
