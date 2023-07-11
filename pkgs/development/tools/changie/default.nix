{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "changie";
  version = "1.12.0";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "miniscruff";
    repo = pname;
    sha256 = "sha256-lc9G5qZHjO2TxBKYP3fVr8Ui+hskhVon3xG7RznGhaw=";
  };

  vendorSha256 = "sha256-sak9MMqMXBO3j5uMouuiVnT8aCw04pyikgqzvdygB7U=";

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
