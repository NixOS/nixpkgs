{ lib, buildGoModule, fetchFromGitHub, installShellFiles, nix-update-script }:

buildGoModule rec {
  pname = "globalping-cli";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "jsdelivr";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-/W/S+oG/3gD/+8mOWy4oWv7TR3IGKZt4cz0vE4nIzM4=";
  };

  vendorHash = "sha256-V6DwV2KukFfFK0PK9MacoHH0sB5qNV315jn0T+4rhfA=";

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
    description = "Simple CLI tool to run networking commands remotely from hundreds of globally distributed servers";
    homepage = "https://www.jsdelivr.com/globalping/cli";
    license = licenses.mpl20;
    maintainers = with maintainers; [ xyenon ];
    mainProgram = "globalping";
  };
}
