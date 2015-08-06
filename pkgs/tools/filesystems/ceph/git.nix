{ callPackage, fetchgit, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "2015-08-05";

  src = fetchgit {
    url = "git://github.com/wkennington/ceph.git";
    rev = "043a780feb973b7ad571bb696437476da3260133";
    sha256 = "02kk24wm6mxsclklsz5zzpj3wm6f341blj2anx3v5x20cixzdnhp";
  };

  patches = [ ./fix-pythonpath.patch ];
})
