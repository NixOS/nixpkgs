{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "grype";
  version = "0.30.0";

  src = fetchFromGitHub {
    owner = "anchore";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-nUNjC1NNscqv+cirC/4/FlrbOomBXxnOoHvCVpBUOUs=";
  };

  vendorSha256 = "sha256-XUj9Az/N/ZzCJF6a7EipPTntwlFYuVhg8JoS+GJES+w=";

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s" "-w" "-X github.com/anchore/grype/internal/version.version=${version}"
  ];

  # Tests require a running Docker instance
  doCheck = false;

  postInstall = ''
    installShellCompletion --cmd grype \
      --bash <($out/bin/grype completion bash) \
      --fish <($out/bin/grype completion fish) \
      --zsh <($out/bin/grype completion zsh)
  '';

  meta = with lib; {
    homepage = "https://github.com/anchore/grype";
    changelog = "https://github.com/anchore/grype/releases/tag/v${version}";
    description = "Vulnerability scanner for container images and filesystems";
    longDescription = ''
      As a vulnerability scanner grype is able to scan the contents of a
      container image or filesystem to find known vulnerabilities.
    '';
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab jk ];
  };
}
