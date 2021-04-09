{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "cloud-nuke";
  version = "0.1.27";

  src = fetchFromGitHub {
    owner = "gruntwork-io";
    repo = pname;
    rev = "v${version}";
    sha256 = "1708g8msv5cw0b4gljyjqns328wbci3p3avwysms4aknm4vky0g0";
  };

  vendorSha256 = "0m7k6k790i06i8a5r8y7787mmikfibbvl7s8xqxygq1f5cpdspd6";

  buildFlagsArray = [ "-ldflags=-s -w -X main.VERSION=${version}" ];

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/gruntwork-io/cloud-nuke";
    description = "A tool for cleaning up your cloud accounts by nuking (deleting) all resources within it";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
