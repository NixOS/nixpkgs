{ lib, buildGoModule, fetchFromGitHub, makeWrapper, iptables, iproute }:

buildGoModule rec {
  pname = "tailscale";
  version = "0.96-33";

  src = fetchFromGitHub {
    owner = "tailscale";
    repo = "tailscale";
    rev = "19cc4f8b8ecfdc16136d8489a1c2b899f556fda7";
    sha256 = "0kcf3mz7fs15dm1dnkvrmdkm3agrl1zlg9ngb7cwfmvkkw1rkl6i";
  };

  nativeBuildInputs = [ makeWrapper ];

  CGO_ENABLED = 0;

  goPackagePath = "tailscale.com";
  modSha256 = "1pjqfzw411k6kw8hqf56irnlhnl8947p1ad8yd84zvqqpzfs3jmz";
  subPackages = [ "cmd/tailscale" "cmd/tailscaled" ];

  postInstall = ''
    wrapProgram $out/bin/tailscaled --prefix PATH : ${
      lib.makeBinPath [ iproute iptables ]
    }
  '';

  meta = with lib; {
    homepage = "https://tailscale.com";
    description = "The node agent for Tailscale, a mesh VPN built on WireGuard";
    platforms = platforms.linux;
    license = licenses.bsd3;
    maintainers = with maintainers; [ danderson mbaillie ];
  };
}
