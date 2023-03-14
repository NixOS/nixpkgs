{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "changie";
  version = "1.11.1";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "miniscruff";
    repo = pname;
    sha256 = "sha256-IZiGNmVEOJf7sqJHXCXxptfy79mSnyyyiqf+oS41MgI=";
  };

  vendorSha256 = "sha256-0/3Ou8z6yLWhc81hdN2gkaFLLlKQWUGcIdvRHVLTrjQ=";

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
