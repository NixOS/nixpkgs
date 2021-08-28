{ lib, buildGoModule, fetchFromGitHub, makeWrapper, iptables, iproute2 }:

buildGoModule rec {
  pname = "tailscale";
  version = "1.8.6";

  src = fetchFromGitHub {
    owner = "tailscale";
    repo = "tailscale";
    rev = "v${version}";
    sha256 = "1h3ry4y62wwcv4z3yjqal4ch4xy40k9s3rq20lqs3r58kblnaxs2";
  };

  nativeBuildInputs = [ makeWrapper ];

  CGO_ENABLED = 0;

  vendorSha256 = "0cppblz1mnyb3c8xcry5mnf566s6l9409vf9572n1rs1bg91dvgn";

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
