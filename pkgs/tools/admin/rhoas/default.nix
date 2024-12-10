{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  testers,
  rhoas,
}:

buildGoModule rec {
  pname = "rhoas";
  version = "0.53.0";

  src = fetchFromGitHub {
    owner = "redhat-developer";
    repo = "app-services-cli";
    rev = "v${version}";
    sha256 = "sha256-9fydRgp2u1LWf0lEDMi1OxxFURd14oKCBDKACqrgWII=";
  };

  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
    "-X github.com/redhat-developer/app-services-cli/internal/build.Version=${version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  # Networking tests fail.
  doCheck = false;

  postInstall = ''
    installShellCompletion --cmd rhoas \
      --bash <($out/bin/rhoas completion bash) \
      --fish <($out/bin/rhoas completion fish) \
      --zsh <($out/bin/rhoas completion zsh)
  '';

  passthru.tests.version = testers.testVersion {
    package = rhoas;
    command = "HOME=$TMP rhoas version";
  };

  meta = with lib; {
    description = "Command Line Interface for Red Hat OpenShift Application Services";
    license = licenses.asl20;
    homepage = "https://github.com/redhat-developer/app-services-cli";
    changelog = "https://github.com/redhat-developer/app-services-cli/releases/v${version}";
    maintainers = with maintainers; [ stehessel ];
    mainProgram = "rhoas";
  };
}
