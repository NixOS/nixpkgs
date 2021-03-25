{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "cloud-nuke";
  version = "0.1.25";

  src = fetchFromGitHub {
    owner = "gruntwork-io";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-tbwmHsiR/RJl3CJrzJtI6GA3v9mNAirbEHXX+wDMd2k=";
  };

  vendorSha256 = "sha256-vOaklBsMuKTQ3cJgXDClM1RWh+ovemO1uDWXeK1ygU4=";

  buildFlagsArray = [ "-ldflags=-s -w -X main.VERSION=${version}" ];

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/gruntwork-io/cloud-nuke";
    description = "A tool for cleaning up your cloud accounts by nuking (deleting) all resources within it";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
