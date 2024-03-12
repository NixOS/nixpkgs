{ lib, buildGoModule, fetchFromGitHub, installShellFiles, testers, atlas }:

buildGoModule rec {
  pname = "atlas";
  version = "0.19.2";

  src = fetchFromGitHub {
    owner = "ariga";
    repo = "atlas";
    rev = "v${version}";
    hash = "sha256-P3KatCF9zoqGRh2N1Rc89wJmsE0bRM5Uoq3zTSdAhTY=";
  };

  modRoot = "cmd/atlas";

  proxyVendor = true;
  vendorHash = "sha256-roMEd/R+WmsWdCT9eye0ijqCcYzSSqVFU9mRN1Sw0jk=";

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [ "-s" "-w" "-X ariga.io/atlas/cmd/atlas/internal/cmdapi.version=v${version}" ];

  subPackages = [ "." ];

  postInstall = ''
    installShellCompletion --cmd atlas \
      --bash <($out/bin/atlas completion bash) \
      --fish <($out/bin/atlas completion fish) \
      --zsh <($out/bin/atlas completion zsh)
  '';

  passthru.tests.version = testers.testVersion {
    package = atlas;
    command = "atlas version";
    version = "v${version}";
  };

  meta = with lib; {
    description = "A modern tool for managing database schemas";
    homepage = "https://atlasgo.io/";
    changelog = "https://github.com/ariga/atlas/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = [ maintainers.marsam ];
    mainProgram = "atlas";
  };
}
