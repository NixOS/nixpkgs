{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "cloud-nuke";
  version = "0.1.29";

  src = fetchFromGitHub {
    owner = "gruntwork-io";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-RPlEFajIjEBKdL97xjQP6r3AAcCQlxw2Il8nkSjxa+k=";
  };

  vendorSha256 = "sha256-pl3dLisu4Oc77kgfuteKbsZaDzrHo1wUigZEkM4081Q=";

  buildFlagsArray = [ "-ldflags=-s -w -X main.VERSION=${version}" ];

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/gruntwork-io/cloud-nuke";
    description = "A tool for cleaning up your cloud accounts by nuking (deleting) all resources within it";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
