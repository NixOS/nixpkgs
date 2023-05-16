{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "kustomize";
<<<<<<< HEAD
  version = "5.1.1";
=======
  version = "5.0.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
<<<<<<< HEAD
    hash = "sha256-XtpMws2o3h19PsRJXKg+y5/Zk3bc6mJ4O1LLZ40ioTM=";
=======
    hash = "sha256-tsri90wvEZ6/UQpFz4fn7FgBQhji1IW1nPcx3jBaa3M=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  # avoid finding test and development commands
  modRoot = "kustomize";
  proxyVendor = true;
<<<<<<< HEAD
  vendorHash = "sha256-/XyxZHhlxD0CpaDAuJbLkOHysLXo1+ThTcexqtNdVIs=";
=======
  vendorHash = "sha256-9XOa3K5PBhnxwQo6eOPkdFcbp6axKTDYHFwzbAKxjEI=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd kustomize \
      --bash <($out/bin/kustomize completion bash) \
      --fish <($out/bin/kustomize completion fish) \
      --zsh <($out/bin/kustomize completion zsh)
  '';

  meta = with lib; {
    description = "Customization of kubernetes YAML configurations";
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
