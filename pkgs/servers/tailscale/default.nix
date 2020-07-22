{ lib, buildGoModule, fetchFromGitHub, makeWrapper, iptables, iproute }:

buildGoModule rec {
  pname = "tailscale";
  # Tailscale uses "git describe" as version numbers. 0.100.0-153
  # means "tag v0.100.0 plus 153 commits", which corresponds to the
  # commit hash below.
  version = "0.100.0-153";

  src = fetchFromGitHub {
    owner = "tailscale";
    repo = "tailscale";
    rev = "v${version}";
    sha256 = "1alvsbkpmkra26imhr2927jqwqxcp9id6y8l9mgxhyh3z7qzql8w";
  };

  nativeBuildInputs = [ makeWrapper ];

  CGO_ENABLED = 0;

  goPackagePath = "tailscale.com";
  vendorSha256 = "0xp8dq3bsaipn9hyp3daqljj3k7zrkbbyk9jph0x59qwpljl0nhz";
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
