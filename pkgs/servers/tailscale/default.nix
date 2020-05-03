{ lib, buildGoModule, fetchFromGitHub, makeWrapper, iptables, iproute }:

buildGoModule rec {
  pname = "tailscale";
  version = "0.97-219";

  src = fetchFromGitHub {
    owner = "tailscale";
    repo = "tailscale";
    # Tailscale uses "git describe" as version numbers. v0.97-219
    # means "tag v0.97 plus 219 commits", which is what this rev is.
    rev = "afbfe4f217a2a202f0eefe943c7c1ef648311339";
    sha256 = "1an897ys3gycdmclqd0yqs9f7q88zxqxyc6r0gcgs4678svxhb68";
  };

  nativeBuildInputs = [ makeWrapper ];

  CGO_ENABLED = 0;

  goPackagePath = "tailscale.com";
  modSha256 = "1xgdhbck3pkix10lfshzdszrv6d3p0hbx8jdjvswz7jjd0vzm4x1";
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
