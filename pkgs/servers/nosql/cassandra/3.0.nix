{ callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  version = "3.0.15";
  sha256 = "1n92wpp5gm41r4agjwjw9ymnnn114pmaqf04c1dx3fksk100wd5g";
})
