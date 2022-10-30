{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "oh-my-posh";
  version = "12.10.0";

  src = fetchFromGitHub {
    owner = "jandedobbeleer";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-iPSaJL1mvPjzZjXtgqeFS1p1jlOqc6B/R1/Zwym0j3g=";
  };

  vendorSha256 = "sha256-OrtKFkWXqVoXKmN6BT8YbCNjR1gRTT4gPNwmirn7fjU=";

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
