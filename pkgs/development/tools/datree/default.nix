{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "datree";
  version = "0.15.5";

  src = fetchFromGitHub {
    owner = "datreeio";
    repo = "datree";
    rev = version;
    sha256 = "sha256-u4bv9sKTeDX2VOG4hUUz0JpF6woGC4/44STij/tYi1I=";
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
