{ callPackage, fetchgit, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "0.94.3";

  src = fetchgit {
    url = "https://github.com/ceph/ceph.git";
    rev = "c19b0fc1aa2834ae3027b07a02aebe9639fc2ca7";
    sha256 = "1h1y5jh2bszia622rmwdblb3cpkpd0mijahkaiasr30jwpkmzh0i";
  };

  patches = [ ./fix-pgrefdebugging.patch ];
})
