{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  kustomize,
  testers,
}:

buildGoModule (finalAttrs: {
  pname = "kustomize";
  version = "5.7.1";

  ldflags =
    let
      t = "sigs.k8s.io/kustomize/api/provenance";
    in
    [
      "-s"
      "-X ${t}.version=v${finalAttrs.version}" # add 'v' prefix to match official releases
      "-X ${t}.gitCommit=${finalAttrs.src.rev}"
    ];

  src = fetchFromGitHub {
    owner = "kubernetes-sigs";
    repo = "kustomize";
    rev = "kustomize/v${finalAttrs.version}";
    hash = "sha256-eLj9OQlHZph/rI3om6S5/0sYxjgYloUWag2mS0hEpCE=";
  };

  # avoid finding test and development commands
  modRoot = "kustomize";
  proxyVendor = true;
  vendorHash = "sha256-OodR5WXEEn4ZlVRTsH2uSmuJuP+6PYRLvTEZCenx4XU=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd kustomize \
      --bash <($out/bin/kustomize completion bash) \
      --fish <($out/bin/kustomize completion fish) \
      --zsh <($out/bin/kustomize completion zsh)
  '';

  passthru.tests = {
    versionCheck = testers.testVersion {
      command = "${finalAttrs.meta.mainProgram} version";
      version = "v${finalAttrs.version}";
      package = kustomize;
    };
  };

  meta = {
    description = "Customization of kubernetes YAML configurations";
    mainProgram = "kustomize";
    longDescription = ''
      kustomize lets you customize raw, template-free YAML files for
      multiple purposes, leaving the original YAML untouched and usable
      as is.
    '';
    homepage = "https://github.com/kubernetes-sigs/kustomize";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      carlosdagos
      vdemeester
      periklis
      zaninime
      Chili-Man
      saschagrunert
    ];
  };
})
