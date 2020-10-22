{ lib, buildGoModule, fetchFromGitHub, makeWrapper, iptables, iproute }:

buildGoModule rec {
  pname = "tailscale";
  version = "1.0.5";

  src = fetchFromGitHub {
    owner = "tailscale";
    repo = "tailscale";
    rev = "v${version}";
    sha256 = "0ib2s694kf5iz5hvrlzfs80z0931dhva7yir80crq0pji9y4rp7b";
  };

  nativeBuildInputs = [ makeWrapper ];

  CGO_ENABLED = 0;

  vendorSha256 = "0l9lzwwvshg9a2kmmq1cvvlaxncbas78a9hjhvjjar89rjr2k2sv";

  doCheck = false;

  subPackages = [ "cmd/tailscale" "cmd/tailscaled" ];

  preBuild = ''
    export buildFlagsArray=(
      -tags="xversion"
      -ldflags="-X tailscale.com/version.LONG=${version} -X tailscale.com/version.SHORT=${version}"
    )
  '';

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
