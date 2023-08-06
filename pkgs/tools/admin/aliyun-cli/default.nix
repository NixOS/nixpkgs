{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "aliyun-cli";
  version = "3.0.170";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "aliyun";
    repo = pname;
    fetchSubmodules = true;
    sha256 = "sha256-PHrut4w66v/TBFZqFoopNJTDhuIjaKdiqA6pHxMKEC0=";
  };

  vendorHash = "sha256-XM/ATJVTyhv85KI2aUTufVDzYZMLTegtNuT3JEsU5vM=";

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
