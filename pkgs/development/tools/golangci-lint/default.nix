{ buildGoModule, fetchFromGitHub, lib, installShellFiles }:

buildGoModule rec {
  pname = "golangci-lint";
  version = "1.60.3";

  src = fetchFromGitHub {
    owner = "golangci";
    repo = "golangci-lint";
    rev = "v${version}";
    hash = "sha256-0ScdJ5td2N8WF1dwHQ3dBSjyr1kqgrzCfBzbRg9cRrw=";
  };

  vendorHash = "sha256-ixeswsfx36D0Tg103swbBD8UXXLNYbxSMYDE+JOm+uw=";

  subPackages = [ "cmd/golangci-lint" ];

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
    "-X main.commit=v${version}"
    "-X main.date=19700101-00:00:00"
  ];

  postInstall = ''
    for shell in bash zsh fish; do
      HOME=$TMPDIR $out/bin/golangci-lint completion $shell > golangci-lint.$shell
      installShellCompletion golangci-lint.$shell
    done
  '';

  meta = with lib; {
    description = "Fast linters Runner for Go";
    homepage = "https://golangci-lint.run/";
    changelog = "https://github.com/golangci/golangci-lint/blob/v${version}/CHANGELOG.md";
    mainProgram = "golangci-lint";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ SuperSandro2000 mic92 ];
  };
}
