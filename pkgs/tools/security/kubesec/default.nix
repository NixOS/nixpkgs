{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "kubesec";
  version = "2.12.0";

  src = fetchFromGitHub {
    owner = "controlplaneio";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-0irZ3mCpXDWc/RovTK9d7AT/Gfbyt1R4WjCJFZ5RFdg=";
  };
  vendorSha256 = "sha256-sRIGehDuAjtpOAYYtqANua8LSzl/+WolZimMxlkG5X8=";

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/controlplaneio/kubesec/v${lib.versions.major version}/cmd.version=v${version}"
  ];

  # Tests wants to download the kubernetes schema for use with kubeval
  doCheck = false;

  postInstall = ''
    installShellCompletion --cmd kubesec \
      --bash <($out/bin/kubesec completion bash) \
      --fish <($out/bin/kubesec completion fish) \
      --zsh <($out/bin/kubesec completion zsh)
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    $out/bin/kubesec --help
    $out/bin/kubesec version | grep "${version}"

    runHook postInstallCheck
  '';

  meta = with lib; {
    description = "Security risk analysis tool for Kubernetes resources";
    homepage = "https://github.com/controlplaneio/kubesec";
    changelog = "https://github.com/controlplaneio/kubesec/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab jk ];
  };
}
