{ substituteAll }:
substituteAll {
  name = "nixos-enter";
  dir = "bin";
  isExecutable = true;
  src = ./nixos-enter.sh;
}
