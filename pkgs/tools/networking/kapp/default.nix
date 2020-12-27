{ lib, buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "kapp";
  version = "0.35.0";

  src = fetchFromGitHub {
    owner = "vmware-tanzu";
    repo = "carvel-kapp";
    rev = "v${version}";
    sha256 = "1i4hpqpbwqb0yg3rx4z733zfslq3svmahfr39ss1ydylsipl02mg";
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
