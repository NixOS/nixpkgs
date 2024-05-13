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
  version = "1.66.1";
in
buildGoModule {
  pname = "tailscale";
  inherit version;

  src = fetchFromGitHub {
    owner = "tailscale";
    repo = "tailscale";
    rev = "v${version}";
    hash = "sha256-1Yt8W/UanAghaElGiD+z7BKeV/Ge+OElA+B9yBnu3vw=";
  };
  vendorHash = "sha256-Hd77xy8stw0Y6sfk3/ItqRIbM/349M/4uf0iNy1xJGw=";

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
