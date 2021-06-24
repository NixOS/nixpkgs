{ lib, buildGoModule, fetchFromGitHub, makeWrapper, iptables, iproute2 }:

buildGoModule rec {
  pname = "tailscale";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "tailscale";
    repo = "tailscale";
    rev = "v${version}";
    sha256 = "07dzcqd98nsrdv72wp93q6f23mn3pfmpyyi61dx6c26w0j5n4r0p";
  };

  nativeBuildInputs = [ makeWrapper ];

  CGO_ENABLED = 0;

  vendorSha256 = "0wbw9pc0cv05bw2gsps3099zipwjj3r23vyf87qy6g21r08xrrm8";

  doCheck = false;

  subPackages = [ "cmd/tailscale" "cmd/tailscaled" ];

  preBuild = ''
    export buildFlagsArray=(
      -tags="xversion"
      -ldflags="-X tailscale.com/version.Long=${version} -X tailscale.com/version.Short=${version}"
    )
  '';

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
