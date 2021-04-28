{ lib, buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "ytt";
  version = "0.31.0";

  src = fetchFromGitHub {
    owner = "vmware-tanzu";
    repo = "carvel-ytt";
    rev = "v${version}";
    sha256 = "sha256-GXnhI8nd4ciFd22989ypqGy5pozKJm+dzg8MaDDvuZg=";
  };

  vendorSha256 = null;

  subPackages = [ "cmd/ytt" ];

  meta = with lib; {
    description = "YAML templating tool that allows configuration of complex software via reusable templates with user-provided values";
    homepage = "https://get-ytt.io";
    license = licenses.asl20;
    maintainers = with maintainers; [ brodes ];
  };
}
