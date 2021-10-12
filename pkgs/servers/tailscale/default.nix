{ lib, stdenv, buildGoModule, fetchFromGitHub, makeWrapper, iptables, iproute2, procps }:

buildGoModule rec {
  pname = "tailscale";
  version = "1.14.6";

  src = fetchFromGitHub {
    owner = "tailscale";
    repo = "tailscale";
    rev = "v${version}";
    sha256 = "sha256-Mvt2j1AAkENT0krl2PbtzM7HXgs4miYXDchFm+8cspY=";
  };

  nativeBuildInputs = lib.optionals stdenv.isLinux [ makeWrapper ];

  CGO_ENABLED = 0;

  vendorSha256 = "sha256-v/jcNKcjE/c4DuxwfCy09xFTDk3yysP4tBmVW69FI4o=";

  doCheck = false;

  subPackages = [ "cmd/tailscale" "cmd/tailscaled" ];

  tags = [ "xversion" ];

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
