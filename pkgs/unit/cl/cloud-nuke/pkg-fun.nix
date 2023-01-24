{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "cloud-nuke";
  version = "0.21.0";

  src = fetchFromGitHub {
    owner = "gruntwork-io";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-DcR5pofMcV2Y5qVA2h3I5h/1qS25+deVAUQWIMLu/KI=";
  };

  vendorSha256 = "sha256-GRHyoKv05JRZiY0g3Xd11liDYPcA6rfE8vorZRCV1wI=";

  ldflags = [ "-s" "-w" "-X main.VERSION=${version}" ];

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/gruntwork-io/cloud-nuke";
    description = "A tool for cleaning up your cloud accounts by nuking (deleting) all resources within it";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
