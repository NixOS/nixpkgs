{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "kustomize";
  version = "5.4.3";

  ldflags = let t = "sigs.k8s.io/kustomize/api/provenance"; in
    [
      "-s"
      "-X ${t}.version=${version}"
      "-X ${t}.gitCommit=${src.rev}"
    ];

  src = fetchFromGitHub {
    owner = "kubernetes-sigs";
    repo = pname;
    rev = "kustomize/v${version}";
    hash = "sha256-DrdExiGDWBrlbNIY6R9SXD4cuVyLBOE3ePw1J3hymHA=";
  };

  # avoid finding test and development commands
  modRoot = "kustomize";
  proxyVendor = true;
  vendorHash = "sha256-cyTZCa1kmNhomkNNnt2Waww4czOZ5YzDBUDx5gqLHtQ=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd kustomize \
      --bash <($out/bin/kustomize completion bash) \
      --fish <($out/bin/kustomize completion fish) \
      --zsh <($out/bin/kustomize completion zsh)
  '';

  meta = with lib; {
    description = "Customization of kubernetes YAML configurations";
    mainProgram = "kustomize";
    longDescription = ''
      kustomize lets you customize raw, template-free YAML files for
      multiple purposes, leaving the original YAML untouched and usable
      as is.
    '';
    homepage = "https://github.com/kubernetes-sigs/kustomize";
    license = licenses.asl20;
    maintainers = with maintainers; [ carlosdagos vdemeester periklis zaninime Chili-Man saschagrunert ];
  };
}
