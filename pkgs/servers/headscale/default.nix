{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
<<<<<<< HEAD
  nixosTests,
}:
buildGoModule rec {
  pname = "headscale";
  version = "0.22.3";
=======
}:
buildGoModule rec {
  pname = "headscale";
  version = "0.22.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "juanfont";
    repo = "headscale";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-nqmTqe3F3Oh8rnJH0clwACD/0RpqmfOMXNubr3C8rEc=";
  };

  vendorHash = "sha256-IOkbbFtE6+tNKnglE/8ZuNxhPSnloqM2sLgTvagMmnc=";
=======
    hash = "sha256-6T4wWuhikanoQGGjVvNJak5yvgcEfhGtOmfLc2xKmms=";
  };

  vendorHash = "sha256-+JxS4Q6rTpdBwms2nkVDY/Kluv2qu2T0BaOIjfeX85M=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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

<<<<<<< HEAD
  passthru.tests = { inherit (nixosTests) headscale; };

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
