{ lib, buildGoPackage, fetchFromGitHub }:

with lib;

buildGoPackage rec {
  name = "flannel-${version}";
  version = "0.6.2";
  rev = "v${version}";

  goPackagePath = "github.com/coreos/flannel";

  hardeningDisable = [ "fortify" ];

  src = fetchFromGitHub {
    inherit rev;
    owner = "coreos";
    repo = "flannel";
    sha256 = "03l0zyv9ajda70zw7jgwlmilw26h849jbb9f4slbycphhvbmpvb9";
  };

  meta = {
    description = "Network fabric for containers, designed for Kubernetes";
    license = licenses.asl20;
    homepage = https://github.com/coreos/flannel;
    maintainers = with maintainers; [offline];
    platforms = with platforms; linux;
  };
}
