{ buildGoModule, fetchFromGitHub, installShellFiles, lib }:

buildGoModule rec {
  pname = "dapr-cli";
  version = "1.7.1";

  src = fetchFromGitHub {
    owner = "dapr";
    repo = "cli";
    rev = "v${version}";
    sha256 = "sha256-gEYN9r5hHRya1nqle8qHaUaOpuBN8cSLJx2FBRqyztw=";
  };

  vendorSha256 = "sha256-RGEoewLDKo+D9Wp/v8PI/LPjCh2rFrdLO/AS4RWFliY=";

  nativeBuildInputs = [ installShellFiles ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  postInstall = ''
    mv $out/bin/cli $out/bin/dapr

    installShellCompletion --cmd dapr \
      --bash <($out/bin/dapr completion bash) \
      --zsh <($out/bin/dapr completion zsh)
  '';

  meta = with lib; {
    description = "A CLI for managing Dapr, the distributed application runtime";
    homepage = "https://dapr.io";
    license = licenses.mit;
    maintainers = with maintainers; [ lucperkins ];
    mainProgram = "dapr";
  };
}
