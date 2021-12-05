{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "aliyun-cli";
  version = "3.0.94";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "aliyun";
    repo = pname;
    fetchSubmodules = true;
    sha256 = "sha256:1l9rzdp9kxxicvp45pa7288zxa07xp7w6aj7d9k9xlzv8l96k6j3";
  };
  vendorSha256 = "sha256:0dklq78bqfidcda8pwd6qwaycah3gndmq9s90h1pqx1isw4frckk";

  subPackages = [ "aliyun-openapi-meta" "main" ];

  ldFlags = "-X 'github.com/aliyun/${pname}/cli.Version=${version}'";

  postInstall = ''
    mv $out/bin/main $out/bin/aliyun
  '';

  meta = with lib; {
    description =
      "Tool to manage and use Alibaba Cloud resources through a command line interface.";
    homepage = "https://github.com/aliyun/aliyun-cli";
    license = licenses.asl20;
    maintainers = with maintainers; [ ornxka ];
  };
}
