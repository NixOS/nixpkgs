{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "aliyun-cli";
  version = "3.0.104";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "aliyun";
    repo = pname;
    fetchSubmodules = true;
    sha256 = "sha256-SxguK71rdNUANYKxXgdrxp7vysj5MP+dPiR0Jwzt5Nc=";
  };

  vendorSha256 = "sha256-c7LsCNcxdHwDBEknXJt9AyrmFcem8YtUYy06vNDBdDY=";

  subPackages = [ "main" ];

  ldFlags = [ "-s" "-w" "-X github.com/aliyun/aliyun-cli/cli.Version=${version}" ];

  postInstall = ''
    mv $out/bin/main $out/bin/aliyun
  '';

  meta = with lib; {
    description = "Tool to manage and use Alibaba Cloud resources through a command line interface";
    homepage = "https://github.com/aliyun/aliyun-cli";
    changelog = "https://github.com/aliyun/aliyun-cli/raw/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ ornxka ];
  };
}
