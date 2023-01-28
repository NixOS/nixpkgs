{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:
buildGoModule rec {
  pname = "headscale";
  version = "0.18.0";

  src = fetchFromGitHub {
    owner = "juanfont";
    repo = "headscale";
    rev = "v${version}";
    hash = "sha256-0viXsBRCiaxBTTKXJngSov5M7toscQUOdXDTr1l0U3I=";
  };

  vendorHash = "sha256-SuKT+b8g6xEK15ry2IAmpS/vwDG+zJqK9nfsWpHNXuU=";

  ldflags = ["-s" "-w" "-X github.com/juanfont/headscale/cmd/headscale/cli.Version=v${version}"];

  nativeBuildInputs = [installShellFiles];
  checkFlags = ["-short"];

  tags = ["ts2019"];

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
    maintainers = with maintainers; [nkje jk kradalby misterio77 ghuntley];
  };
}
