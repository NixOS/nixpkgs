{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "badrobot";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "controlplaneio";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-mLBJLeB85QeC4PYH4FyOI8lHz1OxIJlJbqgDfXTNnhM=";
  };
  vendorHash = "sha256-SB7gGgm7BwMSo4ocKX4UGB+OdjVY92S5YZfOmTl4VEk=";

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/controlplaneio/badrobot/cmd.version=v${version}"
  ];

  postInstall = ''
    installShellCompletion --cmd badrobot \
      --bash <($out/bin/badrobot completion bash) \
      --fish <($out/bin/badrobot completion fish) \
      --zsh <($out/bin/badrobot completion zsh)
  '';

  meta = with lib; {
    homepage = "https://github.com/controlplaneio/badrobot";
    changelog = "https://github.com/controlplaneio/badrobot/blob/v${version}/CHANGELOG.md";
    description = "Operator Security Audit Tool";
    longDescription = ''
      Badrobot is a Kubernetes Operator audit tool. It statically analyses
      manifests for high risk configurations such as lack of security
      restrictions on the deployed controller and the permissions of an
      associated clusterole. The risk analysis is primarily focussed on the
      likelihood that a compromised Operator would be able to obtain full
      cluster permissions.
    '';
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ jk ];
  };
}
