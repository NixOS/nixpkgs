{ callPackage, fetchgit, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "1.0.4";

  src = fetchgit {
    url = "git://git.gniibe.org/gnuk/gnuk.git";
    rev = "93867d0c8b90c485f9832c0047c3a2e17a029aca";
    sha256 = "176vx81m6wnfvamxpp7hfbs1pm692zr0my0z2gid65b6rgffdycd";
  };
})
