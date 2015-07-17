{ callPackage, fetchgit, git, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "2015-07-15";

  src = fetchgit {
    url = "git://github.com/ceph/ceph.git";
    rev = "66dcbaed3c3c8e4b5367ba1cd2859271e692e7e0";
    sha256 = "05jba4zjrkksrra6rz4kby8vv4ja8fa73wvwcw3yn3mn1x9kyz2g";
  };

  patches = [ ./fix-pythonpath.patch ];
})
