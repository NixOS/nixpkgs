{ lib
, buildGoModule
, fetchFromGitHub
, nix-update-script
}:

buildGoModule rec {
  pname = "godns";
  version = "3.0.4";

  src = fetchFromGitHub {
    owner = "TimothyYe";
    repo = "godns";
    rev = "refs/tags/v${version}";
    hash = "sha256-1eJAGBKyTXcFFB7HKkljYQkkidQ3VicHy5MMwHY6iHU=";
  };

  vendorHash = "sha256-iAU62/0MjzxwuMvIobhIZEqDJUpRqwEabnazH7jBRTE=";

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
