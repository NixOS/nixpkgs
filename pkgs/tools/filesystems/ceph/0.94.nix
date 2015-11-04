{ callPackage, fetchgit, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "0.94.5";

  src = fetchgit {
    url = "https://github.com/ceph/ceph.git";
    rev = "refs/tags/v${version}";
    sha256 = "0xjbs26c06awpsas4ywdqvql7hdx37slk49zmc4k8w87ff4wwxmc";
  };

  patches = [ ./fix-pgrefdebugging.patch ];
})
