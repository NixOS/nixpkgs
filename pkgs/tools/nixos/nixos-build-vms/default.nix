{ substituteAll }:
substituteAll {
  name = "nixos-build-vms";
  dir = "bin";
  isExecutable = true;
  src = ./nixos-build-vms.sh;
}
