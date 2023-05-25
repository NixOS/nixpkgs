{ buildGoModule
, fetchFromGitHub
, installShellFiles
, lib
, testers
, kubevirt
}:

buildGoModule rec {
  pname = "kubevirt";
  version = "0.59.0";

  src = fetchFromGitHub {
    owner = "kubevirt";
    repo = "kubevirt";
    rev = "v${version}";
    sha256 = "sha256-4mTq/V4X8eq7g+ltgFD2ZFC7k2yiszG2i2QErttPATE=";
  };

  vendorHash = null;

  subPackages = [ "cmd/virtctl" ];

  tags = [ "selinux" ];

  ldflags = [
    "-X kubevirt.io/client-go/version.gitCommit=v${version}"
    "-X kubevirt.io/client-go/version.gitTreeState=clean"
    "-X kubevirt.io/client-go/version.gitVersion=v${version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd virtctl \
      --bash <($out/bin/virtctl completion bash) \
      --fish <($out/bin/virtctl completion fish) \
      --zsh <($out/bin/virtctl completion zsh)
  '';

  passthru.tests.version = testers.testVersion {
    package = kubevirt;
    command = "virtctl version --client";
    version = "v${version}";
  };

  meta = with lib; {
    description = "Client tool to use advanced features such as console access";
    homepage = "https://kubevirt.io/";
    license = licenses.asl20;
    maintainers = with maintainers; [ haslersn ];
  };
}
