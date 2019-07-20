{ lib, buildGoPackage, fetchFromGitHub }:

with lib;

buildGoPackage rec {
  name = "flannel-${version}";
  version = "0.11.0";
  rev = "v${version}";

  goPackagePath = "github.com/coreos/flannel";

  hardeningDisable = [ "fortify" ];

  src = fetchFromGitHub {
    inherit rev;
    owner = "coreos";
    repo = "flannel";
    sha256 = "0akxlrrsm2w51g0qd7dnsdy0hdajx98sdhxw4iknjr2kn7j3gph9";
  };

  meta = {
    description = "Network fabric for containers, designed for Kubernetes";
    license = licenses.asl20;
    homepage = https://github.com/coreos/flannel;
    maintainers = with maintainers; [johanot offline];
    platforms = with platforms; linux;
  };
}
