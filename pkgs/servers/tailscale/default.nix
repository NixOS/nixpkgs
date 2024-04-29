{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
, makeWrapper
, getent
, iproute2
, iptables
, shadow
, procps
, nixosTests
}:

let
  version = "1.64.2";
in
buildGoModule {
  pname = "tailscale";
  inherit version;

  src = fetchFromGitHub {
    owner = "tailscale";
    repo = "tailscale";
    rev = "v${version}";
    hash = "sha256-DS7C/G1Nj9gIjYwXaEeCLbtH9HbB0tRoJBDjZc/nq5g=";
  };
  vendorHash = "sha256-pYeHqYd2cCOVQlD1r2lh//KC+732H0lj1fPDBr+W8qA=";

  nativeBuildInputs = lib.optionals stdenv.isLinux [ makeWrapper ];

  CGO_ENABLED = 0;

  subPackages = [ "cmd/tailscaled" ];

  ldflags = [
    "-w"
    "-s"
    "-X tailscale.com/version.longStamp=${version}"
    "-X tailscale.com/version.shortStamp=${version}"
  ];

  tags = [
    "ts_include_cli"
  ];

  doCheck = false;

  postInstall = ''
    ln -s $out/bin/tailscaled $out/bin/tailscale
  '' + lib.optionalString stdenv.isLinux ''
    wrapProgram $out/bin/tailscaled \
      --prefix PATH : ${lib.makeBinPath [ iproute2 iptables getent shadow ]} \
      --suffix PATH : ${lib.makeBinPath [ procps ]}

    sed -i -e "s#/usr/sbin#$out/bin#" -e "/^EnvironmentFile/d" ./cmd/tailscaled/tailscaled.service
    install -D -m0444 -t $out/lib/systemd/system ./cmd/tailscaled/tailscaled.service
  '';

  passthru.tests = {
    inherit (nixosTests) headscale;
  };

  meta = with lib; {
    homepage = "https://tailscale.com";
    description = "The node agent for Tailscale, a mesh VPN built on WireGuard";
    license = licenses.bsd3;
    mainProgram = "tailscale";
    maintainers = with maintainers; [ mbaillie jk mfrw ];
  };
}
