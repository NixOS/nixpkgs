{ lib, buildGoModule, fetchFromGitHub, makeWrapper, iptables, iproute }:

buildGoModule rec {
  pname = "tailscale";
  version = "0.98-84";

  src = fetchFromGitHub {
    owner = "tailscale";
    repo = "tailscale";
    # Tailscale uses "git describe" as version numbers. v0.97-219
    # means "tag v0.97 plus 219 commits", which is what this rev is.
    rev = "8b0be7475b9e10170f46adef1ebd34c9af3f785b";
    sha256 = "13zr1qd31igxwkxwmgyjnnnj17x0lbbsiklj0n6zlb5kksq4a5vc";
  };

  nativeBuildInputs = [ makeWrapper ];

  CGO_ENABLED = 0;

  goPackagePath = "tailscale.com";
  modSha256 = "18rzi3qwyxly58zp1h4ps1w4lp0nj991z27fvqk41r2pz3344bzc";
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
