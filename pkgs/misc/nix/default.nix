{stdenv, fetchurl}:

derivation {
  name = "nix-0.5pre789";
  system = stdenv.system;
  builder = ./builder.sh;
  src = fetchurl {
    url = http://catamaran.labs.cs.uu.nl/dist/nix/nix-0.5pre789/nix-0.5pre789.tar.bz2;
    md5 = "1c5c1cd6e8bf9b68cc9df3b70017ce15";
  };
  inherit stdenv;
}
