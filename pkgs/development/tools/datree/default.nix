{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "datree";
  version = "1.6.29";

  src = fetchFromGitHub {
    owner = "datreeio";
    repo = "datree";
    rev = version;
    hash = "sha256-RFm7I9HTI3M0fdGOz4ZXHtQY4Pm86SOz9pcIQLqb7/U=";
  };

  vendorSha256 = "sha256-mEtnZO4AZEcnEHuiAWguT8VelD0yLj1rytl6gPkPKBg=";

  ldflags = [
    "-extldflags '-static'"
    "-s"
    "-w"
    "-X github.com/datreeio/datree/cmd.CliVersion=${version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/datree version | grep ${version} > /dev/null
  '';

  postInstall = ''
    for shell in bash fish zsh; do
      $out/bin/datree completion $shell > datree.$shell
      installShellCompletion datree.$shell
    done
  '';

  doCheck = true;

  meta = with lib; {
    description =
      "CLI tool to ensure K8s manifests and Helm charts follow best practices as well as your organization’s policies";
    homepage = "https://datree.io/";
    license = [ licenses.asl20 ];
    maintainers = [ maintainers.jceb ];
    mainProgram = "datree";
  };
}
