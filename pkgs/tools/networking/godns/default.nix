{ lib
, buildGoModule
, fetchFromGitHub
, nix-update-script
}:

buildGoModule rec {
  pname = "godns";
  version = "2.9.4";

  src = fetchFromGitHub {
    owner = "TimothyYe";
    repo = "godns";
    rev = "refs/tags/v${version}";
    hash = "sha256-7AIr35vsjI5jamvdA1EwTwkr8MiEOjTntFeeg4b7RCw=";
  };

  vendorHash = "sha256-+wnaTrY7Mt6bCNTRZbJDFD75RCHyz5gtFi4DN0ng0/M=";

  # Some tests require internet access, broken in sandbox
  doCheck = false;

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${version}"
  ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "A dynamic DNS client tool supports AliDNS, Cloudflare, Google Domains, DNSPod, HE.net & DuckDNS & DreamHost, etc";
    homepage = "https://github.com/TimothyYe/godns";
    changelog = "https://github.com/TimothyYe/godns/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ yinfeng ];
  };
}
