{ lib, stdenv, buildGoModule, fetchFromGitHub, makeWrapper, iptables, iproute2, procps, shadow, getent }:

buildGoModule rec {
  pname = "tailscale";
  version = "1.32.2";

  src = fetchFromGitHub {
    owner = "tailscale";
    repo = "tailscale";
    rev = "v${version}";
    sha256 = "sha256-CYNHD6TS9KTRftzSn9vAH4QlinqNgU/yZuUYxSvsl/M=";
  };
  vendorSha256 = "sha256-VW6FvbgLcokVGunTCHUXKuH5+O6T55hGIP2g5kFfBsE=";

  nativeBuildInputs = lib.optionals stdenv.isLinux [ makeWrapper ];

  CGO_ENABLED = 0;

  subPackages = [ "cmd/tailscale" "cmd/tailscaled" ];

  ldflags = [ "-X tailscale.com/version.Long=${version}" "-X tailscale.com/version.Short=${version}" ];

  doCheck = false;

  postInstall = lib.optionalString stdenv.isLinux ''
    wrapProgram $out/bin/tailscaled --prefix PATH : ${lib.makeBinPath [ iproute2 iptables getent shadow ]}
    wrapProgram $out/bin/tailscale --suffix PATH : ${lib.makeBinPath [ procps ]}

    sed -i -e "s#/usr/sbin#$out/bin#" -e "/^EnvironmentFile/d" ./cmd/tailscaled/tailscaled.service
    install -D -m0444 -t $out/lib/systemd/system ./cmd/tailscaled/tailscaled.service
  '';

  meta = with lib; {
    homepage = "https://tailscale.com";
    description = "The node agent for Tailscale, a mesh VPN built on WireGuard";
    license = licenses.bsd3;
    maintainers = with maintainers; [ danderson mbaillie twitchyliquid64 jk ];
  };
}
