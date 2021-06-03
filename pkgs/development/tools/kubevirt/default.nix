{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kubevirt";
  version = "0.41.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "033xh8clijxj93avi6qkwfx2756ac5aqrr4hsmh1pgnp9ihxk0wx";
  };

  vendorSha256 = null;

  subPackages = [ "cmd/virtctl" ];

  meta = with lib; {
    description = "A virtual machine management add-on for Kubernetes";
    homepage = "https://github.com/kubevirt/kubevirt";
    maintainers = with maintainers; [ nshalman ];
    license = licenses.asl20;
  };
}
