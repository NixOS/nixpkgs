{ callPackage, fetchgit, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "0.94.3";

  src = fetchgit {
    url = "https://github.com/wkennington/ceph.git";
    rev = "6218aa41e04533f0d6e62b5c7be591c2e99716ec";
    sha256 = "0cyl5i1q6lap5a6vk8fjxfpikhxzwm9zkybg37nibahi2bwjr7rr";
  };

  patches = [ ./fix-pgrefdebugging.patch ];
})
