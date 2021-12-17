{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "aliyun-cli";
  version = "3.0.100";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "aliyun";
    repo = pname;
    fetchSubmodules = true;
    sha256 = "sha256-gS+AN0H1/Xe9DQQfoCX7tAI5fHwEai4ONrAtpX9E6PE=";
  };
  vendorSha256 = "sha256-c7LsCNcxdHwDBEknXJt9AyrmFcem8YtUYy06vNDBdDY=";

  subPackages = ["aliyun-openapi-meta" "main"];

  ldFlags = "-X 'github.com/aliyun/${pname}/cli.Version=${version}'";

  postInstall = ''
    mv $out/bin/main $out/bin/aliyun
  '';

  meta = with lib; {
    description = "Tool to manage and use Alibaba Cloud resources through a command line interface.";
    homepage = "https://github.com/aliyun/aliyun-cli";
    license = licenses.asl20;
    maintainers = with maintainers; [ ornxka ];
  };
}
