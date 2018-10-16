{ substituteAll }:
substituteAll {
  name = "nixos-option";
  dir = "bin";
  isExecutable = true;
  src = ./nixos-option.sh;
}
