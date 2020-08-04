{ lib, buildGoModule, fetchFromGitHub, makeWrapper, iptables, iproute }:

buildGoModule rec {
  pname = "tailscale";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "tailscale";
    repo = "tailscale";
    rev = "v${version}";
    sha256 = "0lxffm4z4qx6psfcxjanlxsrf6iqmkbn19b1pm5ikphqr33y8qqh";
  };

  nativeBuildInputs = [ makeWrapper ];

  CGO_ENABLED = 0;

  goPackagePath = "tailscale.com";
  vendorSha256 = "0l9lzwwvshg9a2kmmq1cvvlaxncbas78a9hjhvjjar89rjr2k2sv";
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
