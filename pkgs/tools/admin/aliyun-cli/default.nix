{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "aliyun-cli";
  version = "3.0.134";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "aliyun";
    repo = pname;
    fetchSubmodules = true;
    sha256 = "sha256-popi+eF0nIA0C9QHbV4cu1vKfv9QUUq8oOJW/XkEabg=";
  };

  vendorSha256 = "sha256-rUYlFM9OlPXGzxXyOxweUs6md7HhjocC56F+OtT/IXo=";

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
