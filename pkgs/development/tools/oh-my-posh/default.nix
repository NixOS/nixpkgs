{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "oh-my-posh";
  version = "12.0.1";

  src = fetchFromGitHub {
    owner = "jandedobbeleer";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-69H3ZhkK0WPiQY2COP5sMR6maoLyYs+Z3LuXHs8ZiJc=";
  };

  vendorSha256 = "sha256-cgE2HMtH6vnXmNheFBLOeBakNloeDs6X7JBry3sp2fc=";

  sourceRoot = "source/src";

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [ "-s" "-w" "-X" "main.Version=${version}" ];

  tags = [ "netgo" "osusergo" "static_build" ];

  postInstall = ''
    mkdir -p $out/share/oh-my-posh
    cp -r ${src}/themes $out/share/oh-my-posh/
    installShellCompletion --cmd oh-my-posh \
      --bash <($out/bin/oh-my-posh completion bash) \
      --fish <($out/bin/oh-my-posh completion fish) \
      --zsh <($out/bin/oh-my-posh completion zsh)
  '';

  meta = with lib; {
    description = "A prompt theme engine for any shell";
    homepage = "https://ohmyposh.dev";
    license = licenses.mit;
    maintainers = with maintainers; [ lucperkins ];
  };
}
