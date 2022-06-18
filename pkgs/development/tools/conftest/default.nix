{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "conftest";
  version = "0.32.1";

  src = fetchFromGitHub {
    owner = "open-policy-agent";
    repo = "conftest";
    rev = "v${version}";
    sha256 = "sha256-lmz5ALGvTwPiz0PaGYlL3UTd6tYgO5rpUHXFoLKgS7E=";
  };
  vendorSha256 = "sha256-Y0S759iPSU7kboa9GxC56QR3caOG9gEmEG44B1Lp3w4=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/open-policy-agent/conftest/internal/commands.version=${version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  preCheck = ''
    export HOME="$TMPDIR"
  '';

  postInstall = ''
    installShellCompletion --cmd conftest \
      --bash <($out/bin/conftest completion bash) \
      --fish <($out/bin/conftest completion fish) \
      --zsh <($out/bin/conftest completion zsh)
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    export HOME="$TMPDIR"
    $out/bin/conftest --version | grep ${version} > /dev/null
  '';

  meta = with lib; {
    description = "Write tests against structured configuration data";
    downloadPage = "https://github.com/open-policy-agent/conftest";
    homepage = "https://www.conftest.dev";
    license = licenses.asl20;
    longDescription = ''
      Conftest helps you write tests against structured configuration data.
      Using Conftest you can write tests for your Kubernetes configuration,
      Tekton pipeline definitions, Terraform code, Serverless configs or any
      other config files.

      Conftest uses the Rego language from Open Policy Agent for writing the
      assertions. You can read more about Rego in 'How do I write policies' in
      the Open Policy Agent documentation.
    '';
    maintainers = with maintainers; [ jk yurrriq ];
  };
}
