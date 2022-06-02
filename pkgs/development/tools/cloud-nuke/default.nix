{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "cloud-nuke";
  version = "0.11.3";

  src = fetchFromGitHub {
    owner = "gruntwork-io";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-iMPTRPsULrwXbx1xQ9db1s0p9a6YejXkwp7sqZ1ayYU=";
  };

  vendorSha256 = "sha256-McCbogZvgm9pnVjay9O2CxAh+653JnDMcU4CHD0PTPI=";

  ldflags = [ "-s" "-w" "-X main.VERSION=${version}" ];

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/gruntwork-io/cloud-nuke";
    description = "A tool for cleaning up your cloud accounts by nuking (deleting) all resources within it";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
