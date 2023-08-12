{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "ytt";
  version = "0.45.3";

  src = fetchFromGitHub {
    owner = "vmware-tanzu";
    repo = "carvel-ytt";
    rev = "v${version}";
    sha256 = "sha256-2Q/a5GXHLh8RO6SLSqh6tiq5D8rPu9ftCQ1FaELwcv0=";
  };

  vendorHash = null;

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-X github.com/vmware-tanzu/carvel-ytt/pkg/version.Version=${version}"
  ];

  subPackages = [ "cmd/ytt" ];

  postInstall = ''
    installShellCompletion --cmd ytt \
      --bash <($out/bin/ytt completion bash) \
      --fish <($out/bin/ytt completion fish) \
      --zsh <($out/bin/ytt completion zsh)
  '';

  meta = with lib; {
    description = "YAML templating tool that allows configuration of complex software via reusable templates with user-provided values";
    homepage = "https://get-ytt.io";
    license = licenses.asl20;
    maintainers = with maintainers; [ brodes techknowlogick ];
  };
}
