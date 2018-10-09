{ substituteAll
, lib
, nix
, nixos-enter
}:
substituteAll {
  name = "nixos-install";
  dir = "bin";
  isExecutable = true;
  src = ./nixos-install.sh;
  nix = nix.out;
  path = lib.makeBinPath [ nixos-enter ];
}
