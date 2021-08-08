{ lib, buildGoModule, fetchFromGitHub, makeWrapper, iptables, iproute2 }:

buildGoModule rec {
  pname = "tailscale";
  version = "1.12.3";

  src = fetchFromGitHub {
    owner = "tailscale";
    repo = "tailscale";
    rev = "v${version}";
    sha256 = "sha256-jjxO35PaxEI9n0qsawTPt3mHNC0PjWfmEA4NkIAwyTY=";
  };

  nativeBuildInputs = [ makeWrapper ];

  CGO_ENABLED = 0;

  vendorSha256 = "sha256-2MPenTV0fgvXbf8WkoPd9uApPSDLPyHtCq9o3CHB/D0=";

  doCheck = false;

  subPackages = [ "cmd/tailscale" "cmd/tailscaled" ];

  tags = [ "xversion" ];

  ldflags = [ "-X tailscale.com/version.Long=${version}" "-X tailscale.com/version.Short=${version}" ];

  postInstall = ''
    wrapProgram $out/bin/tailscaled --prefix PATH : ${
      lib.makeBinPath [ iproute2 iptables ]
    }
    sed -i -e "s#/usr/sbin#$out/bin#" -e "/^EnvironmentFile/d" ./cmd/tailscaled/tailscaled.service
    install -D -m0444 -t $out/lib/systemd/system ./cmd/tailscaled/tailscaled.service
  '';

  meta = with lib; {
    homepage = "https://tailscale.com";
    description = "The node agent for Tailscale, a mesh VPN built on WireGuard";
    platforms = platforms.linux;
    license = licenses.bsd3;
    maintainers = with maintainers; [ danderson mbaillie ];
  };
}
