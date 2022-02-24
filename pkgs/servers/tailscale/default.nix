{ lib, stdenv, buildGoModule, fetchFromGitHub, makeWrapper, iptables, iproute2, procps }:

buildGoModule rec {
  pname = "tailscale";
  version = "1.22.0";

  src = fetchFromGitHub {
    owner = "tailscale";
    repo = "tailscale";
    rev = "v${version}";
    sha256 = "sha256-kBxZFzny61xsLynD0sWz4dd8BzbdZkah0ATnHo3txRM=";
  };

  nativeBuildInputs = lib.optionals stdenv.isLinux [ makeWrapper ];

  CGO_ENABLED = 0;

  vendorSha256 = "sha256-Bu0a9JI0rlsA4wvvX9Mj4+QH0ot6Jdl+t246HbXu6OA=";

  doCheck = false;

  subPackages = [ "cmd/tailscale" "cmd/tailscaled" ];

  ldflags = [ "-X tailscale.com/version.Long=${version}" "-X tailscale.com/version.Short=${version}" ];

  postInstall = lib.optionalString stdenv.isLinux ''
    wrapProgram $out/bin/tailscaled --prefix PATH : ${lib.makeBinPath [ iproute2 iptables ]}
    wrapProgram $out/bin/tailscale --suffix PATH : ${lib.makeBinPath [ procps ]}

    sed -i -e "s#/usr/sbin#$out/bin#" -e "/^EnvironmentFile/d" ./cmd/tailscaled/tailscaled.service
    install -D -m0444 -t $out/lib/systemd/system ./cmd/tailscaled/tailscaled.service
  '';

  meta = with lib; {
    homepage = "https://tailscale.com";
    description = "The node agent for Tailscale, a mesh VPN built on WireGuard";
    license = licenses.bsd3;
    maintainers = with maintainers; [ danderson mbaillie ];
  };
}
