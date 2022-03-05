{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "headscale";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "juanfont";
    repo = "headscale";
    rev = "v${version}";
    sha256 = "sha256-9nBFBvYAhybg97oU4mi899ss4/nzBCY95KfdkSs2f8s=";
  };

  vendorSha256 = "sha256-qFoSK27D6bznksdm7Fl4SsVt13g2LSwuGe0As/MUo5o=";

  ldflags = [ "-s" "-w" "-X github.com/juanfont/headscale/cmd/headscale/cli.Version=v${version}" ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd headscale \
      --bash <($out/bin/headscale completion bash) \
      --fish <($out/bin/headscale completion fish) \
      --zsh <($out/bin/headscale completion zsh)
  '';

  meta = with lib; {
    homepage = "https://github.com/juanfont/headscale";
    description = "An open source, self-hosted implementation of the Tailscale control server";
    longDescription = ''
      Tailscale is a modern VPN built on top of Wireguard. It works like an
      overlay network between the computers of your networks - using all kinds
      of NAT traversal sorcery.

      Everything in Tailscale is Open Source, except the GUI clients for
      proprietary OS (Windows and macOS/iOS), and the
      'coordination/control server'.

      The control server works as an exchange point of Wireguard public keys for
      the nodes in the Tailscale network. It also assigns the IP addresses of
      the clients, creates the boundaries between each user, enables sharing
      machines between users, and exposes the advertised routes of your nodes.

      Headscale implements this coordination server.
    '';
    license = licenses.bsd3;
    maintainers = with maintainers; [ nkje jk kradalby ];
  };
}
