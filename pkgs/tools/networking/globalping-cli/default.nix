{ lib, buildGoModule, fetchFromGitHub, installShellFiles, nix-update-script }:

buildGoModule rec {
  pname = "globalping-cli";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "jsdelivr";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-9FMp3cGJr8RdySZvSflYa91uaIV5wVl6WmUDvbRkSFY=";
  };

  vendorHash = "sha256-3VqCgkyhPKk5iBkKOK2EajEKgEnCHOQjO59AKFafQHc=";

  nativeBuildInputs = [ installShellFiles ];

  CGO_ENABLED = 0;
  ldflags = [ "-s" "-w" "-X main.version=${version}" ];

  postInstall = ''
    mv $out/bin/${pname} $out/bin/globalping
    installShellCompletion --cmd globalping \
      --bash <($out/bin/globalping completion bash) \
      --fish <($out/bin/globalping completion fish) \
      --zsh <($out/bin/globalping completion zsh)
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "A simple CLI tool to run networking commands remotely from hundreds of globally distributed servers";
    homepage = "https://www.jsdelivr.com/globalping/cli";
    license = licenses.mpl20;
    maintainers = with maintainers; [ xyenon ];
    mainProgram = "globalping";
  };
}
