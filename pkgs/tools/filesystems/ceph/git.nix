{ callPackage, fetchgit, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "2015-07-29";

  src = fetchgit {
    url = "git://github.com/ceph/ceph.git";
    rev = "338ead0f498238fd1b5b7f18d86ad407de6f347b";
    leaveDotGit = true;
    sha256 = "0ip62l4qkcmszbczwdnqhn93glnpgy0fhymf627x0vf49dgv3a6i";
  };

  patches = [ ./fix-pythonpath.patch ];
})
