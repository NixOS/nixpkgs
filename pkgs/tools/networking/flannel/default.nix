{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "flannel";
  version = "0.14.0";

  vendorSha256 = null;

  src = fetchFromGitHub {
    owner = "flannel-io";
    repo = "flannel";
    rev = "v${version}";
    sha256 = "sha256-W2yXWieHS0IHsz8JQ9Ie8o0tAFwyEGmUZYaMrIfXFxw=";
  };

  doCheck = false;

  meta = with lib; {
    description = "Network fabric for containers, designed for Kubernetes";
    license = licenses.asl20;
    homepage = "https://github.com/flannel-io/flannel";
    maintainers = with maintainers; [johanot offline];
    platforms = with platforms; linux;
  };
}
