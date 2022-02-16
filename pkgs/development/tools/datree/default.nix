{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "datree";
  version = "0.15.16";

  src = fetchFromGitHub {
    owner = "datreeio";
    repo = "datree";
    rev = version;
    sha256 = "sha256-FIFsx6iSirUY14cn6E7CPhZQKtcgnyZ2fYghrMUx3Lw=";
  };

  vendorSha256 = "sha256-HaOgRbF3gMsl6PufdB5IZ2sLunvPo4GeObLb7DRSD0o=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/datreeio/datree/cmd.CliVersion=${version}"
  ];

  doCheck = true;

  meta = with lib; {
    description = "CLI tool to ensure K8s manifests and Helm charts follow best practices as well as your organization’s policies";
    homepage = "https://datree.io/";
    license = [ licenses.asl20 ];
    maintainers = [ maintainers.jceb ];
  };
}
