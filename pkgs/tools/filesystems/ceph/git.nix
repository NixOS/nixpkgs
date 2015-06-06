{ callPackage, fetchgit, git, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "2015-04-22";

  src = fetchgit {
    url = "git://github.com/ceph/ceph.git";
    rev = "89262abc53e324f3ef4d504473a4f1d6eb337c20";
    sha256 = "0d6hlk1nwgx9cdhvppggz6sbjc1jl8j26l9739qspw1sviac5lcb";
  };
})
