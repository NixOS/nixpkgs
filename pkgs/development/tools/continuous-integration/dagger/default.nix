{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "dagger";
  version = "0.2.11";

  src = fetchFromGitHub {
    owner = "dagger";
    repo = "dagger";
    rev = "v${version}";
    sha256 = "sha256-jkH1OrddLUMSj0Hs5T9jyVVR9F5x7jzIZ8HYixA0x2s=";
  };

  vendorSha256 = "sha256-4GmdgyoqArvjJsQsVjwaxlvOMwYHUTiuD1jOzW8DPKQ=";

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
