{ lib, buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "kapp";
  version = "0.34.0";

  src = fetchFromGitHub {
    owner = "vmware-tanzu";
    repo = "carvel-kapp";
    rev = "v${version}";
    sha256 = "145909cbq4yb25r6ccpdhzfwk60q5g2hw6qdp2h6ja1ckrnvffld";
  };

  vendorSha256 = null;

  subPackages = [ "cmd/kapp" ];

  meta = with lib; {
    description = "CLI tool that encourages Kubernetes users to manage bulk resources with an application abstraction for grouping";
    homepage = "https://get-kapp.io";
    license = licenses.asl20;
    maintainers = with maintainers; [ brodes ];
  };
}
