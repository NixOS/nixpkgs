{ lib, buildGoPackage, fetchFromGitHub }:

with lib;

buildGoPackage rec {
  pname = "flannel";
  version = "0.12.0";
  rev = "v${version}";

  goPackagePath = "github.com/coreos/flannel";

  src = fetchFromGitHub {
    inherit rev;
    owner = "coreos";
    repo = "flannel";
    sha256 = "04g7rzgyi3xs3sf5p1a9dmd08crdrz6y1b02ziv3444qk40jyswd";
  };

  meta = {
    description = "Network fabric for containers, designed for Kubernetes";
    license = licenses.asl20;
    homepage = "https://github.com/coreos/flannel";
    maintainers = with maintainers; [johanot offline];
    platforms = with platforms; linux;
  };
}
