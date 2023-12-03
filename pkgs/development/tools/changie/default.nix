{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "changie";
  version = "1.16.0";

  src = fetchFromGitHub {
    owner = "miniscruff";
    repo = "changie";
    rev = "v${version}";
    hash = "sha256-lFe59ITcPJ69x0COV+WlX500Hl96XqWLCz5gJMqX6qQ=";
  };

  vendorHash = "sha256-JmK7bcS8UYCOUvJGs0PAYPNc8iwvCSFzjLlkBEVUa40=";

  nativeBuildInputs = [
    installShellFiles
  ];

  ldflags = [ "-s" "-w" "-X=main.version=${version}" ];

  postInstall = ''
    installShellCompletion --cmd changie \
      --bash <($out/bin/changie completion bash) \
      --fish <($out/bin/changie completion fish) \
      --zsh <($out/bin/changie completion zsh)
  '';

  meta = with lib; {
    description = "Automated changelog tool for preparing releases with lots of customization options";
    homepage = "https://changie.dev";
    changelog = "https://github.com/miniscruff/changie/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda matthiasbeyer ];
  };
}
