{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "dagger";
  version = "0.2.18";

  src = fetchFromGitHub {
    owner = "dagger";
    repo = "dagger";
    rev = "v${version}";
    sha256 = "sha256-nxBevv7COhywEYeRq1gXAuLswxe2WgHI0Pm78IvzapM=";
  };

  vendorSha256 = "sha256-27cXvgpw4Te0w/rMk6g5jF3UY6N8saArUwfbVO6xpes=";

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
