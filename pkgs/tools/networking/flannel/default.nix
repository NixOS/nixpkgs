{ lib, buildGoPackage, fetchFromGitHub }:

with lib;

buildGoPackage rec {
  pname = "flannel";
  version = "0.13.0";
  rev = "v${version}";

  goPackagePath = "github.com/coreos/flannel";

  src = fetchFromGitHub {
    inherit rev;
    owner = "coreos";
    repo = "flannel";
    sha256 = "0mmswnaybwpf18h832haapcs5b63wn5w2hax0smm3inldiggsbw8";
  };

  meta = {
    description = "Network fabric for containers, designed for Kubernetes";
    license = licenses.asl20;
    homepage = "https://github.com/coreos/flannel";
    maintainers = with maintainers; [johanot offline];
    platforms = with platforms; linux;
  };
}
