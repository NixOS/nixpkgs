{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "aliyun-cli";
  version = "3.0.183";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "aliyun";
    repo = pname;
    fetchSubmodules = true;
    sha256 = "sha256-L00vQTuY4m5vGqu09FyOdM/XOIMyLZG/BSj8dktEa40=";
  };

  vendorHash = "sha256-S8Nthnr3wASvRyZS5UTHILPnUA+FeZJEwIvT0O39U3I=";

  subPackages = [ "main" ];

  ldflags = [ "-s" "-w" "-X github.com/aliyun/aliyun-cli/cli.Version=${version}" ];

  postInstall = ''
    mv $out/bin/main $out/bin/aliyun
  '';

  meta = with lib; {
    description = "Tool to manage and use Alibaba Cloud resources through a command line interface";
    homepage = "https://github.com/aliyun/aliyun-cli";
    changelog = "https://github.com/aliyun/aliyun-cli/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ ornxka ];
    mainProgram = "aliyun";
  };
}
