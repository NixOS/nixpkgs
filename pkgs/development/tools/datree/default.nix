{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "datree";
  version = "1.7.3";

  src = fetchFromGitHub {
    owner = "datreeio";
    repo = "datree";
    rev = "v${version}";
    hash = "sha256-FeGV/GXzt/AHprvKyt/gPAxxJ7d46GXrh0QRLb7qp0E=";
  };

  vendorHash = "sha256-m3O5AoAHSM6rSnmL5N7V37XU38FADb0Edt/EZvvb2u4=";

  CGO_ENABLED = 0;

  tags = [ "main" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/datreeio/datree/cmd.CliVersion=${version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    for shell in bash fish zsh; do
      $out/bin/datree completion $shell > datree.$shell
      installShellCompletion datree.$shell
    done
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/datree version | grep ${version} > /dev/null
  '';

  meta = with lib; {
    description =
      "CLI tool to ensure K8s manifests and Helm charts follow best practices as well as your organization’s policies";
    homepage = "https://datree.io/";
    license = [ licenses.asl20 ];
    maintainers = [ maintainers.jceb ];
    mainProgram = "datree";
  };
}
