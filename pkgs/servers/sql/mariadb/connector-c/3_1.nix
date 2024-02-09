{ callPackage, ... } @ args:

callPackage ./. (args // {
  version = "3.1.21";
  hash = "sha256-guN3Rcsb/EV4rxPE3yhJRSsT1+z44zUetg7ZBA4WjIc=";
})
