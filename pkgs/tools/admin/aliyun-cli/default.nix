{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "aliyun-cli";
  version = "3.0.200";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "aliyun";
    repo = pname;
    fetchSubmodules = true;
    sha256 = "sha256-xUP7zEWq5zTNzDaazmsL2h4QznsE5K3Rzo08qctCA3M=";
  };

  vendorHash = "sha256-t9ukiREUEmW6KK7m5Uv5Ce6n/1GsBLom9H35eEyOBys=";

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
