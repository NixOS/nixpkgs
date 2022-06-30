{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "dagger";
  version = "0.2.20";

  src = fetchFromGitHub {
    owner = "dagger";
    repo = "dagger";
    rev = "v${version}";
    sha256 = "sha256-TlysP5xf8LJoB9MU/sdQIM6yMfsaI8SP+drRlfG+tQ4=";
  };

  vendorSha256 = "sha256-pE6g5z4rOQlqmI9LZQXoI6fRmSTXDv5H8Y+pNXVIcOU=";

  subPackages = [
    "cmd/dagger"
  ];

  ldflags = [ "-s" "-w" "-X go.dagger.io/dagger/version.Revision=${version}" ];

  meta = with lib; {
    description = "A portable devkit for CICD pipelines";
    homepage = "https://dagger.io";
    license = licenses.asl20;
    maintainers = with maintainers; [ jfroche ];
  };
}
